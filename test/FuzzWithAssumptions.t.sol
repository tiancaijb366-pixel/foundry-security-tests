// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

contract FuzzWithAssumptionsTest is Test {
    /// avoid division by zero via vm.assume
    function testFuzz_NoDivisionByZero(uint256 denominator) external {
        vm.assume(denominator != 0);
        uint256 result = 100 / denominator;
        assertTrue(result <= 100);
    }

    /// exclude zero address (common invariant)
    function testFuzz_NoZeroAddress(address user) external {
        vm.assume(user != address(0));
        assertTrue(user != address(0));
    }

    /// bound timestamps to realistic range
    function testFuzz_TimestampInRange(uint256 timestamp) external {
        timestamp = bound(timestamp, 1_700_000_000, 1_800_000_000); // ~2023-2027
        vm.warp(timestamp);
        assertEq(block.timestamp, timestamp);
    }

    /// bound array indices to valid range
    function testFuzz_ArrayIndexInBounds(uint256 index) external {
        uint256[] memory arr = new uint256[](10);
        vm.assume(index < arr.length);
        arr[index] = 42;
        assertEq(arr[index], 42);
    }

    /// assume values are not equal — useful for multi-parameter edge cases
    function testFuzz_NotEqual(uint256 a, uint256 b) external {
        vm.assume(a != b);
        assertTrue(a != b);
    }
}
