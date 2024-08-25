// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@pancakeswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "./interfaces/IWBNB.sol";
import "./utils/JesusCryptUtils.sol";
import "./JesusCryptLiquidityLocker.sol";

abstract contract JesusCryptPresale is ERC20, Ownable, JesusCryptUtils {
    uint256 public constant START_JSCP_PRICE = 10 ** 13;

    // Addresses of USDT, WBNB and Chainlink BNB/USDT price feed
    address public constant USDT_ADDRESS = 0x55d398326f99059fF775485246999027B3197955;
    address public constant WBNB_ADDRESS = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    uint256 public maxAmount = 0;
    uint256 public remainingAmount = 0;
    uint256 public lockedBNB = 0;
    uint256 public lockedUSDT = 0;

    ERC20 public jesusCryptToken;
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

    constructor(address _jesusCryptToken) Ownable() {
        jesusCryptToken = ERC20(_jesusCryptToken);
    }

    function getPresaleRound() public view returns (PresaleRound memory) {
        return presaleRounds[currentRound];
    }

    /**
     * @dev Add liquidity to the PancakeSwap V3 pool with BNB
     * @param _bnbAmount Amount of BNB to add elevated to 18 decimals
     * @notice This function is used to add liquidity to the PancakeSwap V3 pool with BNB, after that the liquidity will be locked for 18 months
     */
    function _addLiquidityBNB(uint256 _bnbAmount) internal returns (address) {
        IWBNB(WBNB_ADDRESS).deposit{value: _bnbAmount}();

        uint256 bnbPriceInUSDT = getLatestBNBPrice();
        uint256 bnbAmountInUSDT = _bnbAmount * bnbPriceInUSDT;
        uint256 tokenAmount = bnbAmountInUSDT / START_JSCP_PRICE;

        require(jesusCryptToken.transferFrom(owner(), address(this), tokenAmount), "Token transfer failed");

        uint256 slippageTolerance = 1;
        uint256 amount0Min = tokenAmount - ((tokenAmount * slippageTolerance) / 100);
        uint256 amount1Min = _bnbAmount - ((_bnbAmount * slippageTolerance) / 100);

        uint160 sqrtPriceX96 = _calculateSqrtPriceX96(START_JSCP_PRICE, true);
        address poolAddress = positionManager.createAndInitializePoolIfNecessary(address(this), WBNB_ADDRESS, 3000, sqrtPriceX96);

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

        return poolAddress;
    }

    /**
     * @dev Add liquidity to the PancakeSwap V3 pool with USDT
     * @param _usdtAmount Amount of USDT to add, must be elevated to 18 decimals
     * @notice This function is used to add liquidity to the PancakeSwap V3 pool with USDT, after that the liquidity will be locked for 18 months
     */
    function _addLiquidityUSDT(uint256 _usdtAmount) internal returns (address) {
        uint256 tokenAmount = _usdtAmount / START_JSCP_PRICE;

        require(jesusCryptToken.transferFrom(owner(), address(this), tokenAmount), "Token transfer failed");

        uint256 slippageTolerance = 1;
        uint256 amount0Min = tokenAmount - ((tokenAmount * slippageTolerance) / 100);
        uint256 amount1Min = _usdtAmount - ((_usdtAmount * slippageTolerance) / 100);

        uint160 sqrtPriceX96 = _calculateSqrtPriceX96(START_JSCP_PRICE, false);
        address poolAddress = positionManager.createAndInitializePoolIfNecessary(address(this), USDT_ADDRESS, 3000, sqrtPriceX96);

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

        return poolAddress;
    }

    /**
     * @dev Get the presale rates
     * @return uint256 Rate of BNB
     * @return uint256 Rate of USDT
     * @notice This function is used to get the presale rates
     */
    function _getPresaleRates() internal view returns (uint256, uint256) {
        uint256 bnbPrice = getLatestBNBPrice();
        uint256 rateBNB;
        uint256 rateUSDT;

        if (currentRound == 1) {
            rateUSDT = 250;
            rateBNB = (rateUSDT * 10 ** 6) / bnbPrice;
        } else if (currentRound == 2) {
            rateUSDT = 200;
            rateBNB = (rateUSDT * 10 ** 6) / bnbPrice;
        } else if (currentRound == 3) {
            rateUSDT = 167;
            rateBNB = (rateUSDT * 10 ** 6) / bnbPrice;
        }

        return (rateBNB / 100, rateUSDT / 100);
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
     * @dev Add a presale holder
     * @param _holder Address of the holder
     * @param _amount Amount of tokens
     * @notice This function is used to add a presale holder
     */
    function addHolder(address _holder, uint256 _amount) external {
        require(_holder != address(0), "Invalid address");
        require(_amount > 0, "Amount must be greater than zero");

        presaleHolders[_holder] = PresaleHolders({totalPresaleAmount: _amount, remainingAmount: _amount, unlockDate: block.timestamp + 365 days});
        presaleHoldersList.push(_holder);
    }

    /**
     * @dev Add liquidity to pancakeswa
     * @notice This function is used to add liquidity to PancakeSwap
     */
    function addLiquidity() public onlyOwner returns (address, address) {
        require(!isPresaleActive(), "Presale has not ended yet");

        address bnbPool;
        address usdtPool;
        if (lockedBNB > 0) {
            bnbPool = _addLiquidityBNB(lockedBNB);
            lockedBNB = 0;
        }

        if (lockedUSDT > 0) {
            usdtPool = _addLiquidityUSDT(lockedUSDT);
            lockedUSDT = 0;
        }

        _updatePresaleHoldersLockTime();

        return (bnbPool, usdtPool);
    }

    /**
     * @dev buyPresaleTokens
     * @return bool Presale ended
     * @return uint256 Token amount
     * @notice This function is used to buy presale tokens
     */
    function buyPresaleTokens() external payable returns (bool, uint256) {
        require(currentRound <= 3, "Presale has ended");
        require(msg.value > 0 || ERC20(USDT_ADDRESS).balanceOf(msg.sender) > 0, "Amount must be greater than zero");

        // Balance must be less than 1,000,000,000 JSCP
        require(
            jesusCryptToken.balanceOf(msg.sender) + msg.value <= 1_000_000_000 * 10 ** 8,
            "Exceeds maximum amount of tokens that can be purchased on presale 1,000,000,000 JSCP"
        );

        if (block.timestamp >= presaleRounds[currentRound].endTime) {
            string memory message = "Current round has ended";
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
            tokenAmount = msg.value * (rateBNB / 100);
            require(tokenAmount > remainingAmount, "Amount exceeds remaining tokens for presale");
            require(jesusCryptToken.transferFrom(owner(), msg.sender, tokenAmount), "Token transfer failed");
            lockedBNB += msg.value;
        } else {
            uint256 usdtAmount = ERC20(USDT_ADDRESS).balanceOf(msg.sender);
            tokenAmount = usdtAmount * presaleRounds[currentRound].rateUSDT;
            require(tokenAmount > remainingAmount, "Amount exceeds remaining tokens for presale");
            require(ERC20(USDT_ADDRESS).transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");
            require(jesusCryptToken.transferFrom(owner(), msg.sender, tokenAmount), "Token transfer failed");
            lockedUSDT += usdtAmount;
        }

        remainingAmount -= tokenAmount;

        if (presaleHolders[msg.sender].totalPresaleAmount == 0) {
            this.addHolder(msg.sender, tokenAmount);
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
     * @param _amount Amount of tokens to transfer
     * @return bool Can transfer
     */
    function canPresaleHolderTransfer(address _holder, uint256 _amount) public returns (bool, string memory) {
        if (block.timestamp >= presaleHolders[_holder].unlockDate) {
            uint256 maxTransferAmount = (presaleHolders[_holder].totalPresaleAmount * 10) / 100;
            if (_amount > maxTransferAmount) {
                string memory message = string(
                    abi.encodePacked(
                        "Exceeds maximum amount of tokens that can be transferred, you can only transfer 10% of the presale tokens at a time:",
                        maxTransferAmount,
                        " tokens"
                    )
                );
                return (false, message);
            }

            uint256 remainingHolderAmount = _amount > presaleHolders[_holder].remainingAmount ? 0 : presaleHolders[_holder].remainingAmount - _amount;
            presaleHolders[_holder].unlockDate = presaleHolders[_holder].unlockDate + 7 days;
            presaleHolders[_holder].remainingAmount = remainingHolderAmount;
        } else {
            uint256[] memory untilDate = toDateTime(presaleHolders[_holder].unlockDate);
            return (
                false,
                string(
                    abi.encodePacked(
                        "Presale tokens are still locked until ",
                        untilDate[0],
                        "-",
                        untilDate[1],
                        "-",
                        untilDate[2],
                        " ",
                        untilDate[3],
                        ":",
                        untilDate[4],
                        ":",
                        untilDate[5]
                    )
                )
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
     * @dev Set amounts
     * @param _maxAmount Maximum amount of tokens
     * @param _remainingAmount Remaining amount of tokens
     * @notice This function is used to set the amounts
     */
    function setAmounts(uint256 _maxAmount, uint256 _remainingAmount) external onlyOwner {
        maxAmount = _maxAmount;
        remainingAmount = _remainingAmount;
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
    function setLiquidityLocker(address _liquidityLocker) external onlyOwner {
        liquidityLocker = JesusCryptLiquidityLocker(_liquidityLocker);
    }

    /**
     * @dev Start the presale
     * @param _duration Duration of the presale
     * @param _pancakeSwapPairBNB Address of the PancakeSwap pair with BNB
     * @param _pancakeSwapPairUSDT Address of the PancakeSwap pair with USDT
     * @return uint256 Current round
     * @return uint256 Duration
     * @return uint256 Remaining amount
     * @notice This function is used to start the presale
     */
    function startPresale(uint256 _duration, address _pancakeSwapPairBNB, address _pancakeSwapPairUSDT) external onlyOwner returns (uint256, uint256, uint256) {
        require(_duration > 0, "Duration must be greater than zero");
        require(_pancakeSwapPairBNB != address(0), "PancakeSwap pair must be set");
        require(_pancakeSwapPairUSDT != address(0), "PancakeSwap pair must be set");
        require(remainingAmount > 0, "All presale tokens have been sold");

        if (currentRound > 0 && block.timestamp > presaleRounds[currentRound].endTime) {
            revert("Can't start a new round before the current one ends");
        }

        (, uint256 rateUSDT) = _getPresaleRates();

        // Set presale start time
        if (presaleStartTime == 0) {
            presaleStartTime = block.timestamp;
        }

        currentRound++;

        // Set presale properties
        presaleRounds[currentRound] = PresaleRound({rateUSDT: rateUSDT, endTime: block.timestamp + _duration});
        pancakeSwapPairBNB = _pancakeSwapPairBNB;
        pancakeSwapPairUSDT = _pancakeSwapPairUSDT;

        return (currentRound, _duration, remainingAmount);
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
