// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Vault {
    mapping(address => uint256) public balances;
    uint256 public totalDeposits;

    function deposit(uint256 amount) external {
        balances[msg.sender] += amount;
        totalDeposits += amount;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient balance");
        balances[msg.sender] -= amount;
        totalDeposits -= amount;
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}
