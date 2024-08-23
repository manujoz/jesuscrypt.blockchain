// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@pancakeswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "./interfaces/IWBNB.sol";
import "./utils/JesusCryptUtils.sol";
import "./JesusCryptLiquidityLocker.sol";

contract JesusCryptPresale is IERC20, Ownable, JesusCryptUtils {
    uint256 public constant START_JSCP_PRICE = 0.00001;

    // Addresses of USDT, WBNB and Chainlink BNB/USDT price feed
    address public constant USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;
    address public constant WBNB_ADDRESS = 0xBB4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    uint256 public maxAmount = 0;
    uint256 public remainingAmount = 0;
    uint256 public lockedBNB = 0;
    uint256 public lockedUSDT = 0;

    IERC20 public jesusCryptToken;
    INonfungiblePositionManager public positionManager;
    JesusCryptLiquidityLocker public liquidityLocker;

    struct PresaleRound {
        uint256 rateUSDT;
        uint256 endTime;
    }

    PresaleRound[3] public presaleRounds;
    uint256 public presaleStartTime = 0;
    bool public allPresaleRoundsEnded = false;
    uint256 public currentRound = 0;
    address public pancakeSwapPairBNB;
    address public pancakeSwapPairUSDT;

    struct PresaleHolders {
        uint256 totalPresaleAmount;
        uint256 remainingAmount;
        uint256 unlockDate;
    }
    mapping(address => PresaleHolders) public presaleHolders;
    address[] public presaleHoldersList;

    constructor(address _jesusCryptToken) Ownable(msg.sender) {
        jesusCryptToken = IERC20(_jesusCryptToken);
    }

    /**
     * @dev Add liquidity to the PancakeSwap V3 pool with BNB
     * @param bnbAmount Amount of BNB to add
     * @param tokenAmount Amount of tokens to add
     * @notice This function is used to add liquidity to the PancakeSwap V3 pool with BNB, after that the liquidity will be locked for 18 months
     */
    function _addLiquidityBNB(uint256 _bnbAmount) internal {
        IWBNB(WBNB_ADDRESS).deposit{value: _bnbAmount}();

        uint256 bnbPriceInUSDT = getLatestBNBPrice();
        uint256 bnbAmountInUSDT = (_bnbAmount * bnbPriceInUSDT) / 1e18;
        uint256 tokenAmount = bnbAmountInUSDT / START_JSCP_PRICE;

        require(jesusCryptToken.transferFrom(owner(), address(this), tokenAmount), "Token transfer failed");

        uint256 slippageTolerance = 1;
        uint256 amount0Min = tokenAmount - ((tokenAmount * slippageTolerance) / 100);
        uint256 amount1Min = _bnbAmount - ((_bnbAmount * slippageTolerance) / 100);

        uint160 sqrtPriceX96 = _calculateSqrtPriceX96(START_JSCP_PRICE * 1e18, true);
        positionManager.createAndInitializePoolIfNecessary(address(this), WBNB_ADDRESS, 3000, sqrtPriceX96);

        (uint256 tokenId, , , ) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: address(jesusCryptToken),
                token1: WBNB_ADDRESS,
                fee: 3000,
                tickLower: -887272,
                tickUpper: 887272,
                amount0Desired: tokenAmount,
                amount1Desired: _bnbAmount,
                amount0Min: amount0Min,
                amount1Min: amount1Min,
                recipient: address(liquidityLocker),
                deadline: block.timestamp
            })
        );

        liquidityLocker.lockLiquidity(tokenId, block.timestamp + 18 * 30);
    }

    /**
     * @dev Add liquidity to the PancakeSwap V3 pool with USDT
     * @param usdtAmount Amount of USDT to add
     * @param tokenAmount Amount of tokens to add
     * @notice This function is used to add liquidity to the PancakeSwap V3 pool with USDT, after that the liquidity will be locked for 18 months
     */
    function _addLiquidityUSDT(uint256 _usdtAmount) internal {
        uint256 tokenAmount = _usdtAmount / START_JSCP_PRICE;

        require(jesusCryptToken.transferFrom(owner(), address(this), tokenAmount), "Token transfer failed");

        uint256 slippageTolerance = 1;
        uint256 amount0Min = tokenAmount - ((tokenAmount * slippageTolerance) / 100);
        uint256 amount1Min = _usdtAmount - ((_usdtAmount * slippageTolerance) / 100);

        uint160 sqrtPriceX96 = _calculateSqrtPriceX96(START_JSCP_PRICE * 1e18, false);
        positionManager.createAndInitializePoolIfNecessary(address(this), USDT_ADDRESS, 3000, sqrtPriceX96);

        (uint256 tokenId, , , ) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: address(jesusCryptToken),
                token1: USDT_ADDRESS,
                fee: 3000,
                tickLower: -887272,
                tickUpper: 887272,
                amount0Desired: tokenAmount,
                amount1Desired: _usdtAmount,
                amount0Min: amount0Min,
                amount1Min: amount1Min,
                recipient: address(liquidityLocker),
                deadline: block.timestamp
            })
        );

        liquidityLocker.lockLiquidity(tokenId, block.timestamp + 18 * 30);
    }

    /**
     * @dev Get the presale rates
     * @return uint256 Rate of BNB
     * @return uint256 Rate of USDT
     * @notice This function is used to get the presale rates
     */
    function _getPresaleRates() internal returns (uint256, uint256) {
        uint256 bnbPrice = getLatestBNBPrice();
        uint256 rateBNB;
        uint256 rateUSDT;

        if (currentRound == 1) {
            rateUSDT = 2.5;
            rateBNB = (rateUSDT * 10 ** 8) / bnbPrice;
        } else if (currentRound == 2) {
            rateUSDT = 2;
            rateBNB = (rateUSDT * 10 ** 8) / bnbPrice;
        } else if (currentRound == 3) {
            rateUSDT = 1.67;
            rateBNB = (rateUSDT * 10 ** 8) / bnbPrice;
        }

        return (rateBNB, rateUSDT);
    }

    /**
     * @dev Update presale holders lock time
     * @notice This function is used to update presale holders lock time after liquidity is added
     */
    function _updatePresaleHoldersLockTime() internal {
        for (uint256 i = 0; i < presaleHoldersList.length; i++) {
            address holder = presaleHoldersList[i];
            if (block.timestamp >= presaleHolders[holder].unlockDate) {
                presaleHolders[holder].unlockDate = block.timestamp + 10 days;
            }
        }
    }

    /**
     * @dev Add liquidity to pancakeswa
     * @notice This function is used to add liquidity to PancakeSwap
     */
    function addLiquidity() public onlyOwner {
        require(!isPresaleActive(), "Presale has not ended yet");

        if (lockedBNB > 0) {
            _addLiquidityBNB(lockedBNB);
            lockedBNB = 0;
        }

        if (lockedUSDT > 0) {
            _addLiquidityUSDT(lockedUSDT);
            lockedUSDT = 0;
        }

        _updatePresaleHoldersLockTime();
    }

    /**
     * @dev buyPresaleTokens
     * @return bool Presale ended
     * @return uint256 Token amount
     * @notice This function is used to buy presale tokens
     */
    function buyPresaleTokens() external payable returns (bool, uint256) {
        require(currentRound <= 3, "Presale has ended");
        require(msg.value > 0 || IERC20(USDT_ADDRESS).balanceOf(msg.sender) > 0, "Amount must be greater than zero");

        // Balance must be less than 1,000,000,000 JSCP
        require(
            jesusCryptToken.balanceOf(msg.sender) + msg.value <= 1_000_000_000 * 10 ** 8,
            "Exceeds maximum amount of tokens that can be purchased on presale 1,000,000,000 JSCP"
        );

        if (block.timestamp >= presaleRounds[currentRound].endTime) {
            string message = "Current round has ended";
            if (!isPresaleActive()) {
                message = "Presale has ended";
            }

            revert(message);
        }

        if (remainingAmount == 0) {
            allPresaleRoundsEnded = true;
            currentRound = 3;
            revert("Tokens for presale have been sold out");
        }

        uint256 tokenAmount;
        if (msg.value > 0) {
            (uint256 rateBNB, ) = _getPresaleRates();
            tokenAmount = msg.value * rateBNB;
            require(tokenAmount > remainingAmount, "Amount exceeds remaining tokens for presale");
            require(jesusCryptToken.transferFrom(owner(), msg.sender, tokenAmount), "Token transfer failed");
            lockedBNB += msg.value;
        } else {
            uint256 usdtAmount = IERC20(USDT_ADDRESS).balanceOf(msg.sender);
            tokenAmount = usdtAmount * presaleRounds[currentRound].rateUSDT;
            require(tokenAmount > remainingAmount, "Amount exceeds remaining tokens for presale");
            require(IERC20(USDT_ADDRESS).transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");
            require(jesusCryptToken.transferFrom(owner(), msg.sender, tokenAmount), "Token transfer failed");
            lockedUSDT += usdtAmount;
        }

        remainingAmount -= tokenAmount;

        if (!presaleHolders[msg.sender]) {
            presaleHolders[msg.sender] = PresaleHolders({totalPresaleAmount: tokenAmount, remainingAmount: tokenAmount, unlockDate: block.timestamp + 365 days});
            presaleHoldersList.push(msg.sender);
        } else {
            presaleHolders[msg.sender].totalPresaleAmount += tokenAmount;
            presaleHolders[msg.sender].remainingAmount += tokenAmount;
        }

        bool presaleEnded = false;
        if (block.timestamp >= presaleRounds[currentRound].endTime) {
            presaleEnded = true;
        }

        return (presaleEnded, tokenAmount);
    }

    /**
     * @dev Check if the presale holder can transfer tokens
     * @param _holder Address of the holder
     * @param _value Amount of tokens to transfer
     * @return bool Can transfer
     */
    function canPresaleHolderTransfer(address _holder, uint256 _amount) public view returns (bool, string memory) {
        if (block.timestamp >= presaleHolders[_holder].unlockDate) {
            uint256 maxAmount = (presaleHolders[_holder].totalPresaleAmount * 10) / 100;
            if (_amount > maxAmount) {
                return (false, "Exceeds maximum amount of tokens that can be transferred, you can only transfer 10% of the presale tokens at a time:" + maxAmount + " tokens");
            }

            uint256 memory remainingAmount = _amount > presaleHolders[_holder].remainingAmount ? 0 : presaleHolders[_holder].remainingAmount - _amount;
            presaleHolders[_holder].unlockDate = presaleHolders[_holder].unlockDate + 7 days;
            presaleHolders[_holder].remainingAmount = remainingAmount;
        } else {
            untilDate = toDateTime(presaleHolders[_holder].unlockDate);
            return (
                false,
                "Presale tokens are still locked until " + untilDate[0] + "-" + untilDate[1] + "-" + untilDate[2] + " " + untilDate[3] + ":" + untilDate[4] + ":" + untilDate[5]
            );
        }

        return (true, "");
    }

    /**
     * @dev Check if the presale has ended
     * @return bool Presale ended
     * @notice This function is used to check if the presale has ended
     */
    function isPresaleActive() public returns (bool) {
        if (allPresaleRoundsEnded) {
            return false;
        }

        if (currentRound == 3 && block.timestamp >= presaleRounds[currentRound].endTime) {
            allPresaleRoundsEnded = true;
            return false;
        }

        return true;
    }

    /**
     * @dev Check if an address is a presale holder
     * @param _holder Address of the holder
     * @return bool Is presale holder
     * @notice This function is used to check if an address is a presale holder
     */
    function isPresaleHolder(address _holder) public view returns (bool) {
        return presaleHolders[_holder].totalPresaleAmount > 0;
    }

    /**
     * @dev Set PancakeSwap position manager
     * @param _positionManager Address of the PancakeSwap position manager
     * @notice This function is used to set the PancakeSwap position manager
     */
    function setPancakeSwapPositionManager(address _positionManager) external onlyOwner {
        positionManager = INonfungiblePositionManager(_positionManager);
    }

    /**
     * @dev Set Liquidity Locker contract
     * @param _liquidityLocker Address of the Liquidity Locker contract
     * @notice This function is used to set the Liquidity Locker contract, NOTE: this function must be called after setting the PancakeSwap position manager
     */
    function setLiquidtyLocker(address _liquidityLocker) external onlyOwner {
        liquidityLocker = JesusCryptLiquidityLocker(_liquidityLocker);
        liquidityLocker.positionManager = address(positionManager);
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
        require(_duration > 0, "Duration must be greater than zero");
        require(_pancakeSwapPairBNB != address(0), "PancakeSwap pair must be set");
        require(_pancakeSwapPairUSDT != address(0), "PancakeSwap pair must be set");
        require(remainingAmount > 0, "All presale tokens have been sold");

        if (currentRound > 0 && block.timestamp > presalesRounds[currentRound].endTime) {
            revert("Can't start a new round before the current one ends");
        }

        (, rateUSDT) = _getPresaleRates();

        // Set presale start time
        if (presaleStartTime == 0) {
            presaleStartTime = block.timestamp;
        }

        currentRound++;

        // Set presale properties
        presaleRounds[currentRound] = PresaleRound({rateUSDT: rateUSDT, endTime: block.timestamp + _duration});
        pancakeSwapPairBNB = _pancakeSwapPairBNB;
        pancakeSwapPairUSDT = _pancakeSwapPairUSDT;
    }

    /**
     * @dev Transfer tokens
     * @param _to Address to transfer tokens to
     * @param _value Amount of tokens to transfer
     * @return bool Transfer successful
     * @notice This function avoid withdraw founds until the presale ends
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        if (msg.sender != address(this)) {
            return super.transfer(_to, _value);
        } else {
            require(allPresaleRoundsEnded, "Transfers not allowed until presale ends");
            return super.transfer(_to, _value);
        }
    }

    /**
     * @dev Transfer tokens from
     * @param _sender Address to transfer tokens from
     * @param _recipient Address to transfer tokens to
     * @param _amount Amount of tokens to transfer
     * @return bool Transfer successful
     * @notice This function block withdraw founcs until the presale ends
     */
    function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
        if (_sender != address(this)) {
            return super.transferFrom(_sender, _recipient, _amount);
        } else {
            require(allPresaleRoundsEnded, "Transfers not allowed until presale ends");
            return super.transferFrom(_sender, _recipient, _amount);
        }
    }
}
