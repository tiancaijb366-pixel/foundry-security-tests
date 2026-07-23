// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract InvariantERC20Test is Test {
    Token token;
    address constant user1 = address(0x1001);
    address constant user2 = address(0x1002);

    function setUp() external {
        token = new Token(1_000_000e18);
        // distribute some tokens
        token.transfer(user1, 100_000e18);
        token.transfer(user2, 200_000e18);
    }

    /// canonical ERC20 invariant: totalSupply = sum of all balances
    function invariant_TotalSupplyEqualsSumOfBalances() external {
        uint256 sum = token.balanceOf(address(this))
            + token.balanceOf(user1)
            + token.balanceOf(user2);
        // also check burn address and token contract itself
        sum += token.balanceOf(address(0));
        sum += token.balanceOf(address(token));
        assertEq(token.totalSupply(), sum);
    }

    /// no single address can hold more than totalSupply
    function invariant_NoBalanceExceedsTotalSupply() external {
        assertLe(token.balanceOf(address(this)), token.totalSupply());
        assertLe(token.balanceOf(user1), token.totalSupply());
        assertLe(token.balanceOf(user2), token.totalSupply());
    }

    /// totalSupply is immutable (no mint/burn in this token)
    function invariant_TotalSupplyNeverChanges() external {
        assertEq(token.totalSupply(), 1_000_000e18);
    }
}
