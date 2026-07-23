// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract FuzzBasicTest is Test {
    Vault vault;

    function setUp() external {
        vault = new Vault();
    }

    /// fuzz with vm.assume to avoid overflow waste
    function testFuzz_Deposit(uint256 amount) external {
        vm.assume(amount <= type(uint128).max);
        vault.deposit(amount);
        assertEq(vault.getBalance(address(this)), amount);
    }

    /// fuzz with bound() to keep inputs in a productive range
    function testFuzz_DepositThenWithdraw(uint256 amount) external {
        amount = bound(amount, 1, 1e30);
        vault.deposit(amount);
        vault.withdraw(amount);
        assertEq(vault.getBalance(address(this)), 0);
    }

    /// multi-parameter fuzz: sum of deposits equals balance
    function testFuzz_MultipleDeposits(uint256 a, uint256 b) external {
        a = bound(a, 1, 1e30);
        b = bound(b, 1, 1e30);
        vault.deposit(a);
        vault.deposit(b);
        assertEq(vault.getBalance(address(this)), a + b);
    }

    /// fuzz with zero — should fail on withdrawal
    function testFuzz_WithdrawZero() external {
        vm.expectRevert("insufficient balance");
        vault.withdraw(0);
    }
}
