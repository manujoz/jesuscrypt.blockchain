// SPDX-License-Identifier: MIT
pragma solidity ^0.7.5;

interface IWBNB {
    function deposit() external payable;
    function withdraw(uint256) external;
}
