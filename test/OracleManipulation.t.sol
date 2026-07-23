// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/SimpleOracle.sol";
import "../src/OracleConsumer.sol";

contract OracleManipulationTest is Test {
    SimpleOracle oracle;
    OracleConsumer consumer;

    function setUp() external {
        oracle = new SimpleOracle();
        consumer = new OracleConsumer(address(oracle));
    }

    /// extreme price values should not break the consumer
    function testFuzz_ExtremePrice(uint256 price) external {
        price = bound(price, 1, type(uint128).max);
        oracle.setPrice(price);
        consumer.updateCollateral();
        assertTrue(consumer.getCollateral() > 0);
    }

    /// rapid price swings between any two values
    function testFuzz_RapidPriceChange(uint256 price1, uint256 price2) external {
        price1 = bound(price1, 1e12, 1e24);
        price2 = bound(price2, 1e12, 1e24);
        oracle.setPrice(price1);
        consumer.updateCollateral();
        uint256 before = consumer.getCollateral();
        oracle.setPrice(price2);
        consumer.updateCollateral();
        uint256 after = consumer.getCollateral();
        // after a price change, collateral should still be valid (> 0)
        assertTrue(after > 0);
    }

    /// price of zero should revert in consumer
    function testFuzz_ZeroPriceReverts() external {
        oracle.setPrice(0);
        vm.expectRevert("zero price");
        consumer.updateCollateral();
    }

    /// fuzzing: any caller can update collateral based on oracle price
    function testFuzz_AnyoneCanUpdateCollateral(address caller) external {
        vm.assume(caller != address(0));
        oracle.setPrice(1000);
        vm.prank(caller);
        consumer.updateCollateral();
        assertEq(consumer.getCollateral(), 1e18 / 1000);
    }
}
