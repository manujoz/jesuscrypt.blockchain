// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/JesusCryptUtils.sol";

abstract contract JesusCryptAdvisors is IERC20, Ownable, JesusCryptUtils {
    IERC20 public jesusCryptToken;

    uint256 public maxAmountForOneAdvisor;
    uint256 public maxAmountForAdvisors;

    struct Advisor {
        uint256 amount;
        uint256 remainingAmount;
        uint256 unlockTime;
    }
    mapping(address => Advisor) public advisors;
    address[] public advisorsList;

    uint256 private liquidityAddedTime = 0;

    constructor(address _jesusCryptToken) Ownable() {
        jesusCryptToken = IERC20(_jesusCryptToken);
    }

    /**
     * @dev Check if advisor tokens are locked
     * @param _advisor Address of the advisor
     * @return bool True if advisor tokens are locked, false otherwise
     * @notice This function is used to check if advisor tokens are locked
     */
    function advisorTokensIsLockeds(address _advisor) public view returns (bool) {
        if (liquidityAddedTime == 0) {
            return false;
        }

        if (block.timestamp > liquidityAddedTime + 90 days) {
            return true;
        }

        if (advisors[_advisor].unlockTime > block.timestamp) {
            return false;
        }

        return true;
    }

    /**
     * @dev Check if advisor amount to withdraw is allowed
     * @param _advisor Address of the advisor
     * @param _amount Amount of tokens to withdraw
     * @return bool True if the amount is allowed, false otherwise
     * @notice This function is used to check if advisor amount to withdraw is allowed
     */
    function advisorAmountToWithdrawAllowed(address _advisor, uint256 _amount) public view returns (bool) {
        if (block.timestamp > liquidityAddedTime + 90 days) {
            return true;
        }

        uint256 amountAlowed = (advisors[_advisor].amount * 10) / 100;

        if (_amount > amountAlowed) {
            return false;
        }

        return true;
    }

    /**
     * @dev Check if an address is an advisor
     * @param _advisor Address of the advisor
     * @return bool True if the address is an advisor, false otherwise
     * @notice This function is used to check if an address is an advisor
     */
    function isAdvisor(address _advisor) public view returns (bool) {
        return advisors[_advisor].amount > 0;
    }

    /**
     * @dev Transfer tokens to advisors
     * @param _to Address of the advisor
     * @param _amount Amount of tokens to transfer
     * @notice This function is used to transfer tokens to advisors, maximum 10% of the total supply and maximum 0.3% of the total supply for each advisor
     */
    function transferToAdvisor(address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "ERC20: transfer to the zero address");

        uint256 balance = IERC20(jesusCryptToken).balanceOf(address(this));
        require(_amount <= balance, "Exceeds maximum advisors amount");

        uint256 totalAmount = balance + _amount;

        if (totalAmount > maxAmountForAdvisors) {
            revert(string(abi.encodePacked("Exceeds maximum advisors amount 0.3% of the total supply. Current amount ", uint2str(balance), ", amount added ", uint2str(_amount))));
        }

        if (advisors[_to].amount > 0) {
            require(advisors[_to].amount + _amount <= maxAmountForOneAdvisor, "Exceeds maximum for an advisor 1,500,000,000 JSCP");
            advisors[_to].amount += _amount;
        } else {
            advisorsList.push(_to);
            advisors[_to] = Advisor({amount: _amount, remainingAmount: _amount, unlockTime: 365 days});
        }

        IERC20(jesusCryptToken).transfer(_to, _amount);
    }

    /**
     * @dev Update advisor amount
     * @param _advisor Address of the advisor
     * @param _amount Amount of tokens to update
     * @notice This function is used to update advisor amount
     */
    function updateAdvisor(address _advisor, uint256 _amount) public onlyOwner {
        if (advisors[_advisor].amount == 0) {
            return;
        }

        uint256 newAmount = advisors[_advisor].remainingAmount - _amount;

        advisors[_advisor].unlockTime = block.timestamp + 7 days;
        advisors[_advisor].remainingAmount = newAmount > 0 ? newAmount : 0;
    }

    /**
     * @dev Liquidity for jesuscryptToken is added
     * @notice This function is used to transfer all the tokens to JesusCryptToken contract when liquidity is added and reset advisors unlock time
     */
    function liquidityAdded() external onlyOwner {
        _resetAdvisorsUnlockTime();

        liquidityAddedTime = block.timestamp;

        uint256 balance = IERC20(jesusCryptToken).balanceOf(address(this));
        if (balance > 0) {
            IERC20(jesusCryptToken).transfer(address(jesusCryptToken), balance);
        }
    }

    /**
     * @dev Reset advisors unlock time
     * @notice This function is used to reset advisors unlock time to 10 days from addLiquidity time. This function is called when addLiquidity is called in JesusCryptToken contract
     */
    function _resetAdvisorsUnlockTime() internal {
        for (uint256 i = 0; i < advisorsList.length; i++) {
            advisors[advisorsList[i]].unlockTime = block.timestamp + 10 days;
        }
    }

    function setMaxAmounts(uint256 _maxAmountForOneAdvisor, uint256 _maxAmountForAdvisors) external onlyOwner {
        maxAmountForOneAdvisor = _maxAmountForOneAdvisor;
        maxAmountForAdvisors = _maxAmountForAdvisors;
    }
}
