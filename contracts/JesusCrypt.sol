// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@pancakeswap/v3-core/contracts/interfaces/IPancakeV3Pool.sol";
import "@pancakeswap/v3-core/contracts/libraries/TickMath.sol";
import "./interfaces/AggregatorV3Interface.sol";
import "./lib/JesusCryptUtils.sol";
import "./JesusCryptPresale.sol";
import "./JesusCryptAdvisors.sol";

contract JesusCrypt is ERC20, Ownable, Pausable {
    using JesusCryptUtils for *;

    // Initial supply of the token
    uint256 public constant INITIAL_SUPPLY = 500_000_000_000 * 10 ** 18;

    // Addresses of USDT, WBNB and Chainlink BNB/USDT price feed
    address public constant USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;
    address public constant WBNB_ADDRESS = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    // Developers percent, presale max percent and marketing max percent tokenomics
    uint256 public constant DEVELOPERS_PERCENT = 15;
    uint256 public constant PRESALE_MAX_PERCENT = 35;
    uint256 public constant ADVISORS_MAX_PERCENT = 10;
    uint256 public constant ADIVSORS_MAX_TOKENS = 1500000000 * 10 ** 18;

    // PancakeSwap properties, liquidity control and presale
    JesusCryptPresale public presale;
    JesusCryptAdvisors public advisors;

    // If limited is true, the token will have a maximum and minimum holding amount
    // maxHoldingAmount: Maximum amount of tokens that can be held by an address
    // minHoldingAmount: Minimum amount of tokens that must be held by an address
    struct PairRules {
        bool limited;
        uint256 maxHoldingAmount;
        uint256 minHoldingAmount;
    }
    mapping(address => PairRules) private pairRules;
    address[] private pairRulesAddresses;

    // Pause properties
    string public pauseReason;
    uint256 public pauseExpiration = 0;

    // Tokens locked properties
    uint256 public unlockDate = 0;
    uint256 public tokensLocked = 0;
    uint256 public totalLockedTokens = 0;

    address public bnbPoolAddress;
    address public usdtPoolAddress;

    // Events
    event TokensPurchasedPresale(address indexed purchaser, uint256 amountBNB, uint256 amountTokens);
    event PresaleStarted(uint256 currentRound, uint256 endTime, uint256 remainingTokens);

    /**
     * @dev Constructor function
     * @notice This function is used to initialize the contract
     */
    constructor() ERC20("JesusCrypt", "JSCP") Ownable() {
        // Mint the initial supply
        _mint(msg.sender, INITIAL_SUPPLY);
        approve(address(this), INITIAL_SUPPLY);
    }

    /**
     * @dev Update function to check if the caller is the PancakeSwap pair
     */
    function _beforeTokenTransfer(address _from, address _to, uint256 _value) internal override whenNotPaused {
        if (pairRules[_from].limited) {
            PairRules memory rules = pairRules[_from].limited ? pairRules[_from] : pairRules[_to];
            if (rules.limited) {
                require(balanceOf(_to) + _value <= rules.maxHoldingAmount, "Exceeds maximum holding amount");
                require(balanceOf(_to) + _value >= rules.minHoldingAmount, "Below minimum holding amount");
            }
        }

        if (address(presale) != address(0) && _from == address(presale) && !presale.isPresaleEnded()) {
            revert("Transfers not allowed until presale ends");
        }

        if (address(presale) != address(0) && _from == presale.getLiquididtyLockerAddress() && block.timestamp < presale.getLiquidityLockerUnlockTime()) {
            revert("Transfers not allowed because liquidity is locked");
        }

        if (address(presale) != address(0) && presale.isPresaleHolder(_from)) {
            (bool canTransfer, string memory message) = presale.canPresaleHolderTransfer(_from, _value);
            if (!canTransfer) {
                revert(message);
            }
        }

        if (address(advisors) != address(0) && advisors.isAdvisor(_from)) {
            require(!advisors.advisorTokensIsLockeds(_from), "Advisor tokens are still locked");
            require(!advisors.advisorAmountToWithdrawAllowed(_from, _value), "Exceeds maximum amount of tokens that can be withdrawn");
            advisors.updateAdvisor(_from, _value);
        }

        _unlockTokens();

        super._beforeTokenTransfer(_from, _to, _value);
    }

    /**
     * @dev Lock the remaining tokens
     * @notice This function is used to lock the remaining owner tokens for 3 months
     */
    function _lockRemainingTokens() internal onlyOwner {
        require(unlockDate > 0, "Tokens are already locked");

        // Lock all owner's tokens for 3 months
        unlockDate = block.timestamp + 3 * 30 days;
        totalLockedTokens = balanceOf(owner());

        if (totalLockedTokens == 0) {
            revert("No tokens to lock");
        }

        require(transferFrom(owner(), address(this), totalLockedTokens), "Token transfer failed");
    }

    /**
     * @dev Unlock the tokens
     * @notice This function is used to unlock the tokens. 10% after 3 months from lock date and 10% every 15 days after that till all tokens are unlocked
     */
    function _unlockTokens() internal {
        if (totalLockedTokens == 0 || tokensLocked == 0 || block.timestamp >= unlockDate) {
            return;
        }

        uint256 amountToUnlock = totalLockedTokens / 10;
        if (tokensLocked < amountToUnlock) {
            amountToUnlock = tokensLocked;
        }

        uint256 burnAmount = (amountToUnlock * 1) / 100;
        uint256 reinvestAmount = amountToUnlock - burnAmount;

        _burn(address(this), burnAmount);
        _transfer(address(this), owner(), reinvestAmount);

        tokensLocked -= amountToUnlock;
        if (tokensLocked > 0) {
            unlockDate = block.timestamp + 15 days;
        } else {
            unlockDate = 0;
            renounceOwnership();
        }
    }

    /**
     * @dev Add liquidity to PancakeSwap
     * @notice This function is used to add liquidity to PancakeSwap
     */
    function addLiquidity() public onlyOwner {
        (bnbPoolAddress, usdtPoolAddress) = presale.addLiquidity();
        advisors.liquidityAdded();
        require(approve(address(presale), 0), "Token disapproval failed");

        _lockRemainingTokens();
    }

    /**
     * @dev Burn the specified amount of tokens from the caller
     * @param _account Amount of tokens to burn
     * @param _amount Amount of tokens to burn
     * @notice This function is used to burn the specified amount of tokens from the caller
     */
    function burn(address _account, uint256 _amount) public {
        _burn(_account, _amount);
    }

    /**
     * @dev Buy tokens with BNB or USDT
     * @notice This function is used to buy tokens with BNB or USDT
     */
    function buyPresaleTokens() external payable {
        (, uint256 tokenAmount) = presale.buyPresaleTokens();

        emit TokensPurchasedPresale(msg.sender, msg.value > 0 ? msg.value : ERC20(USDT_ADDRESS).balanceOf(msg.sender), tokenAmount);
    }

    /**
     * @dev Get the decimals of the token
     * @return uint8 Decimals of the token
     * @notice This function is used to get the decimals of the token
     */
    function decimals() public view virtual override returns (uint8) {
        return 8;
    }

    /**
     * @dev Get the lates JSCP price
     * @return uint256 Latest JSCP price
     * @notice This function is used to get the latest JSCP price in USDT
     */
    function getTokenPrice() public view returns (uint256) {
        IPancakeV3Pool bnbPool = IPancakeV3Pool(bnbPoolAddress);
        uint32[] memory secondsAgo = new uint32[](2);
        secondsAgo[0] = 0;
        secondsAgo[1] = 1;
        (int56[] memory tickCumulative, ) = bnbPool.observe(secondsAgo);
        int56 tickCumulativeDelta = tickCumulative[1] - tickCumulative[0];
        int24 tick = int24(tickCumulativeDelta);

        uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);
        uint256 jscpBnbPrice = (uint256(sqrtPriceX96) * uint256(sqrtPriceX96)) / (1 << 192);
        uint256 bnbUsdtPrice = JesusCryptUtils.getLatestBNBPrice();

        return jscpBnbPrice * bnbUsdtPrice;
    }

    /**
     * @dev Get rules for the token
     * @return PairRules[] Array of rules for the token
     * @notice This function is used to get rules for the token like maximum and minimum holding amount
     */
    function getRules() public view returns (PairRules[] memory) {
        PairRules[] memory rulesArray;
        for (uint256 i = 0; i < pairRulesAddresses.length; i++) {
            rulesArray[i] = pairRules[pairRulesAddresses[i]];
        }

        return rulesArray;
    }

    /**
     * @dev Pause the contract
     * @param _reason Reason to pause the contract
     * @param _pauseExpiration Expiration date of the pause
     * @notice This function is used to pause the contract
     */
    function pause(string memory _reason, uint256 _pauseExpiration) public onlyOwner {
        pauseReason = _reason;
        pauseExpiration = _pauseExpiration;
        _pause();
    }

    /**
     * @dev Remove a rule for the token
     * @param _pancakeSwapPair Address of the PancakeSwap pair
     * @notice This function is used to remove a rule for the token
     */
    function removeRule(address _pancakeSwapPair) external onlyOwner {
        delete pairRules[_pancakeSwapPair];
        for (uint256 i = 0; i < pairRulesAddresses.length; i++) {
            if (pairRulesAddresses[i] == _pancakeSwapPair) {
                pairRulesAddresses[i] = pairRulesAddresses[pairRulesAddresses.length - 1];
                pairRulesAddresses.pop();
                break;
            }
        }
    }

    /**
     * @dev Set advisors contract
     * @param _jesusCryptAdvisors Address of the JesusCryptAdvisors contract
     */
    function setAdvisors(address _jesusCryptAdvisors) external onlyOwner {
        advisors = JesusCryptAdvisors(_jesusCryptAdvisors);

        uint256 advisorsMaxAmount = (INITIAL_SUPPLY * ADVISORS_MAX_PERCENT) / 100;
        uint256 advisorsMaxAmountForOneAdvisor = ADIVSORS_MAX_TOKENS;

        advisors.setMaxAmounts(advisorsMaxAmountForOneAdvisor, advisorsMaxAmount);
    }

    /**
     * @dev Set Presale contract
     * @param _presale Address of the Presale contract
     * @param _developers Array of developers addresses
     * @notice This function is used to set the Presale contract
     */
    function setPresale(address _presale, address _liquidityLocker, address _positionManager, address[] memory _developers) external onlyOwner {
        presale = JesusCryptPresale(_presale);

        presale.setPancakeSwapPositionManager(_positionManager);
        presale.setLiquidityLocker(_liquidityLocker);

        uint256 presaleMaxAmount = (INITIAL_SUPPLY * 25) / 100;
        presale.setAmounts(presaleMaxAmount, presaleMaxAmount);

        require(approve(_presale, balanceOf(owner())), "Failing approving");

        uint256 allowanceAmount = allowance(owner(), address(this));
        require(allowanceAmount >= ((INITIAL_SUPPLY * DEVELOPERS_PERCENT) / 100), "Allowance amount is not sufficient");

        // Transfer 15% of the total supply to the developers
        uint256 amountToDevs = ((INITIAL_SUPPLY * DEVELOPERS_PERCENT) / 100) / _developers.length;
        for (uint256 i = 0; i < _developers.length; i++) {
            _transfer(owner(), _developers[i], amountToDevs);
            presale.addHolder(_developers[i], amountToDevs);
        }
    }

    /**
     * @dev Set rules for the token
     * @param _pancakeSwapPair Address of the PancakeSwap pair
     * @notice This function is used to set rules for the token like maximum and minimum holding amount
     */
    function setRule(bool _limited, address _pancakeSwapPair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
        bool exists = false;
        for (uint256 i = 0; i < pairRulesAddresses.length; i++) {
            if (pairRulesAddresses[i] == _pancakeSwapPair) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            pairRulesAddresses.push(_pancakeSwapPair);
        }

        pairRules[_pancakeSwapPair] = PairRules({limited: _limited, maxHoldingAmount: _maxHoldingAmount, minHoldingAmount: _minHoldingAmount});
    }

    /**
     * @dev Start the presale
     * @param _duration Duration of the presale
     * @param _pancakeSwapPairBNB Address of the PancakeSwap pair with BNB
     * @param _pancakeSwapPairUSDT Address of the PancakeSwap pair with USDT
     * @notice This function is used to start the presale
     */
    function startPresale(uint256 _duration, address _pancakeSwapPairBNB, address _pancakeSwapPairUSDT) external onlyOwner {
        (uint256 currentRound, uint256 endTime, uint256 remainingAmount) = presale.startPresale(_duration, _pancakeSwapPairBNB, _pancakeSwapPairUSDT);
        emit PresaleStarted(currentRound, endTime, remainingAmount);
    }

    /**
     * @dev Unpause the contract
     * @notice This function is used to unpause the contract
     */
    function unpause() public onlyOwner {
        pauseReason = "";
        pauseExpiration = 0;
        _unpause();
    }
}
