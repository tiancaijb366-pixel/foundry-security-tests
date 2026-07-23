// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./SimpleOracle.sol";

contract OracleConsumer {
    SimpleOracle public oracle;
    uint256 public collateralRequired;

    constructor(SimpleOracle _oracle) {
        oracle = _oracle;
    }

    function updateCollateral() external {
        uint256 price = oracle.getPrice();
        require(price > 0, "zero price");
        // collateral = 1 / price (in wei-scale)
        collateralRequired = 1e18 / price;
    }

    function getCollateral() external view returns (uint256) {
        return collateralRequired;
    }
}
