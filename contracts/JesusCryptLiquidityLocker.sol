// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract JesusCryptLiquidityLocker is ERC20, Ownable {
    struct Lock {
        address token;
        uint256 amount;
        uint256 unlockTime;
    }

    Lock public liquidityLocked;

    address public pancakePositionManager;

    event TokensLocked(address indexed token, uint256 amount, uint256 unlockTime);
    event TokensWithdrawn(address indexed token, uint256 amount);

    constructor() Ownable() {}

    /**
     * @dev Lock liquidity
     * @param _tokenId Token ID
     * @param _unlockTIme Unlock time
     * @notice This function is used to lock liquidity
     */
    function lockLiquidity(uint256 _tokenId, uint256 _unlockTIme) external onlyOwner {
        require(_tokenId > 0, "Amount must be greater than zero");
        require(_unlockTIme > block.timestamp, "Unlock time must be in the future");

        liquidityLocked = Lock({token: pancakePositionManager, amount: _tokenId, unlockTime: _unlockTIme});

        emit TokensLocked(pancakePositionManager, _tokenId, _unlockTIme);
    }

    /**
     * @dev Transfer tokens
     * @param _to Address to transfer tokens to
     * @param _value Amount of tokens to transfer
     * @return bool Transfer successful
     * @notice This function avoid withdraw LP tokens until the unlock time
     */
    function transfer(address _to, uint256 _value) public override returns (bool) {
        if (msg.sender != address(this)) {
            return super.transfer(_to, _value);
        } else {
            require(block.timestamp >= liquidityLocked.unlockTime, "Transfers not allowed because liquidity is locked");
            return super.transfer(_to, _value);
        }
    }

    /**
     * @dev Withdraw liquidity from a locked token
     * @notice This function is used to withdraw liquidity from a locked token, the token must be unlocked
     */
    function withdrawLiquidity() external onlyOwner {
        require(block.timestamp >= liquidityLocked.unlockTime, "Tokens are still locked");
        require(liquidityLocked.amount > 0, "No tokens to withdraw");

        uint256 amount = liquidityLocked.amount;
        liquidityLocked.amount = 0;

        IERC20(liquidityLocked.token).transfer(msg.sender, amount);

        emit TokensWithdrawn(liquidityLocked.token, amount);
    }

    /**
     * @dev Get locked tokens
     * @return Lock[] Array of locked tokens
     * @notice This function is used to get locked tokens
     */
    function getLiquidityLocked() external view returns (Lock memory) {
        return liquidityLocked;
    }
}
