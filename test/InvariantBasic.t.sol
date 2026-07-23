// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Vault.sol";

contract InvariantBasicTest is Test {
    Vault vault;

    function setUp() external {
        vault = new Vault();
    }

    /// totalDeposits must never underflow (always >= 0)
    function invariant_TotalDepositsGeZero() external {
        assertGe(vault.totalDeposits(), 0);
    }

    /// totalDeposits must be >= any single known balance
    function invariant_TotalDepositsGeAnyBalance() external {
        address anyUser = makeAddr("any");
        assertGe(vault.totalDeposits(), vault.getBalance(anyUser));
    }

    /// vault must never hold ETH (it's a pure uint256 vault)
    function invariant_NoEthInVault() external {
        assertEq(address(vault).balance, 0);
    }
}
