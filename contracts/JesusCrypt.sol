// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@pancakeswap/v3-core/contracts/interfaces/IPancakeV3Pool.sol";
import "./interfaces/AggregatorV3Interface.sol";
import "./utils/JesusCryptUtils.sol";
import "./JesusCryptPresale.sol";
import "./JesusCryptAdvisors.sol";

contract JesusCrypt is ERC20, Ownable, Pausable, JesusCryptUtils {
    // Initial supply of the token
    uint256 public constant START_JSCP_PRICE = 0.00001;
    uint256 public constant INITIAL_SUPPLY = 500_000_000_000 * 10 ** 8;

    // Addresses of USDT, WBNB and Chainlink BNB/USDT price feed
    address public constant USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;
    address public constant WBNB_ADDRESS = 0xBB4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    // Developers percent, presale max percent and marketing max percent tokenomics
    uint256 public constant DEVELOPERS_PERCENT = 15;
    uint256 public constant PRESALE_MAX_PERCENT = 35;
    uint256 public constant ADVISORS_MAX_PERCENT = 10;
    uint256 public constant ADVISOR_MAX_PERCENT = 0.3;

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

    // Events
    event TokensPurchasedPresale(address indexed purchaser, uint256 amountBNB, uint256 amountTokens);
    event PresaleStarted(uint256 currentRound, uint256 endTime, uint256 remainingTokens);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Constructor function
     * @param _positionManager Address of the PancakeSwap position manager
     * @param _liquidityLocker Address of the liquidity locker
     * @param _developers Array of developers addresses
     * @notice This function is used to initialize the contract
     */
    constructor(address[] memory _developers) ERC20("JesusCrypt", "JSCP") Ownable(msg.sender) {
        // Mint the initial supply
        _mint(msg.sender, INITIAL_SUPPLY);
        approve(address(this), INITIAL_SUPPLY);

        // Transfer 15% of the total supply to the developers
        uint256 amountToDevs = (INITIAL_SUPPLY * DEVELOPERS_PERCENT) / 100 / _developers.length;
        for (uint256 i = 0; i < _developers.length; i++) {
            presale.presaleHolders[_developers[i]] = presale.PresaleHolders({
                totalPresaleAmount: amountToDevs,
                remainingAmount: amountToDevs,
                unlockDate: presale.START_TRADING_DATE + 10 days
            });
            _transfer(msg.sender, _developers[i], amountToDevs);
        }

        // Pause the contract till start trading date
        pause("Trading is not allowed till 2024-10-10 00:00:00 UTC", presale.START_TRADING_DATE);
    }

    /**
     * @dev Lock the remaining tokens
     * @param _lockDuration Duration to lock the tokens
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
     * @dev Update function to check if the caller is the PancakeSwap pair
     */
    function _update(address _from, address _to, uint256 _value) internal override whenNotPaused {
        if (pairRules[_from].limited) {
            PairRules memory rules = pairRules[_from] ? pairRules[_from] : pairRules[_to];
            if (rules.limited) {
                require(balanceOf(_to) + _value <= rules.maxHoldingAmount, "Exceeds maximum holding amount");
                require(balanceOf(_to) + _value >= rules.minHoldingAmount, "Below minimum holding amount");
            }
        }

        if (presale.presaleHolders[_from].remainingAmount > 0) {
            if (block.timestamp >= presale.presaleHolders[_from].unlockDate) {
                uint256 maxAmount = (presale.presaleHolders[_from].totalPresaleAmount * 10) / 100;
                if (_value > maxAmount) {
                    revert("Exceeds maximum amount of tokens that can be transferred, you can only transfer 10% of the presale tokens at a time:" + maxAmount + " tokens");
                }

                uint256 memory remainingAmount = _value > presale.presaleHolders[_from].remainingAmount ? 0 : presale.presaleHolders[_from].remainingAmount - _value;
                presale.presaleHolders[_from].unlockDate = presale.presaleHolders[_from].unlockDate + 7 days;
                presale.presaleHolders[_from].remainingAmount = remainingAmount;
            } else {
                untilDate = toDateTime(presale.presaleHolders[_from].unlockDate);
                revert(
                    "Presale tokens are still locked until " + untilDate[0] + "-" + untilDate[1] + "-" + untilDate[2] + " " + untilDate[3] + ":" + untilDate[4] + ":" + untilDate[5]
                );
            }
        }

        if (advisors.isAdvisor(_from)) {
            require(!advisors.advisorTokensIsLockeds(_from), "Advisor tokens are still locked");
            require(!advisors.advisorAmountToWithdrawAllowed(_from, _value), "Exceeds maximum amount of tokens that can be withdrawn");
            advisors.updateAdvisor(_from, _value);
        }

        _unlockTokens();

        super._update(_from, _to, _value);
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

        uint256 burnAmount = (amountToUnlock * 0.5) / 100;
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
        presale.addLiquidity();
        advisors.liquidityAdded();
        require(approve(address(presale), 0), "Token disapproval failed");

        _lockRemainingTokens();
    }

    /**
     * @dev Burn the specified amount of tokens from the caller
     * @param amount Amount of tokens to burn
     * @notice This function is used to burn the specified amount of tokens from the caller
     */
    function burn(address _account, uint256 _amount) public {
        _burn(_account, _amount);
    }

    /**
     * @dev Buy tokens with BNB or USDT
     * @param isBNB True if the purchase is with BNB, false if it is with USDT
     * @notice This function is used to buy tokens with BNB or USDT
     */
    function buyPresaleTokens() external payable {
        if (paused()) {
            _unpause();
        }

        (presaleEnded, tokenAmount) = presale.buyPresaleTokens();

        emit TokensPurchasedPresale(msg.sender, msg.value > 0 ? msg.value : ERC20(USDT_ADDRESS).balanceOf(msg.sender), tokenAmount);

        if (pauseReason != "" && !paused() && presaleEnded && presale.currentRound == 3) {
            _pause();
        }
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
     * @dev Get rules for the token
     * @return PairRules[] Array of rules for the token
     * @notice This function is used to get rules for the token like maximum and minimum holding amount
     */
    function getRules() public view returns (PairRules[] memory) {
        PairRules[] memory rulesArray = new PairRules;
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
        uint256 advisorsMaxAmountForOneAdvisor = (INITIAL_SUPPLY * ADVISOR_MAX_PERCENT) / 100;
        advisors.maxAmountForAdvisors = advisorsMaxAmount;
        advisors.maxAmountForOneAdvisor = advisorsMaxAmountForOneAdvisor;
    }

    /**
     * @dev Set Presale contract
     * @param _presale Address of the Presale contract
     * @notice This function is used to set the Presale contract
     */
    function setPresale(address _presale) external onlyOwner {
        presale = JesusCryptPresale(_presale);

        uint256 presaleMaxAmount = (INITIAL_SUPPLY * 25) / 100;
        presale.maxAmount = presaleMaxAmount;
        presale.remainingAmount = presaleMaxAmount;

        approve(_presale, balanceOf(owner()));
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
     * @param _rateBNB Number of tokens per BNB
     * @param _rateUSDT Number of tokens per USDT
     * @param _duration Duration of the presale
     * @param _pancakeSwapPairBNB Address of the PancakeSwap pair with BNB
     * @param _pancakeSwapPairUSDT Address of the PancakeSwap pair with USDT
     * @notice This function is used to start the presale
     */
    function startPresale(uint256 _duration, address _pancakeSwapPairBNB, address _pancakeSwapPairUSDT) external onlyOwner {
        presale.startPresale(_duration, _pancakeSwapPairBNB, _pancakeSwapPairUSDT);
        emit PresaleStarted(presale.currentRound, presale.presaleHolders[presale.currentRound].endTime, presale.remainingAmount);
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
