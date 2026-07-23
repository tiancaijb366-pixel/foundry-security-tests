// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";

contract GasAssertionsTest is Test {
    /// benchmark: gas cost of SSTORE under fuzzed values
    function testFuzz_GasSstore(uint256 value) external {
        vm.assume(value != 0);
        uint256 slot;
        uint256 gasBefore = gasleft();
        assembly {
            sstore(slot, value)
        }
        uint256 gasUsed = gasBefore - gasleft();
        // SSTORE should use well under the block gas limit
        assertTrue(gasUsed < 50000);
        emit log_named_uint("sstore gas", gasUsed);
    }

    /// benchmark: gas cost of a single MLOAD
    function testFuzz_GasMload() external {
        uint256 slot;
        uint256 val;
        uint256 gasBefore = gasleft();
        assembly {
            val := mload(slot)
        }
        uint256 gasUsed = gasBefore - gasleft();
        assertTrue(gasUsed < 10000);
        emit log_named_uint("mload gas", gasUsed);
    }

    /// benchmark: gas cost of keccak256 for varying input lengths
    function testFuzz_GasKeccak(uint256 len) external {
        len = bound(len, 1, 1024);
        bytes memory data = new bytes(len);
        uint256 gasBefore = gasleft();
        keccak256(data);
        uint256 gasUsed = gasBefore - gasleft();
        // keccak256 for < 1KB should be cheap
        assertTrue(gasUsed < 50000);
        emit log_named_uint("keccak256 gas", gasUsed);
    }

    /// assert gas cost stays bounded — useful for DoS resistance
    function testAssert_GasBounded() external {
        uint256 gasBefore = gasleft();
        for (uint256 i; i < 10; i++) {
            // simple arithmetic, should be cheap
            uint256 x = i * i;
        }
        uint256 gasUsed = gasBefore - gasleft();
        assertTrue(gasUsed < 100000);
    }
}
