// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/AccessControlled.sol";

contract AccessControlTest is Test {
    AccessControlled ac;
    address constant owner = address(0x100);
    address constant operator = address(0x101);

    function setUp() external {
        vm.prank(owner);
        ac = new AccessControlled();
        vm.prank(owner);
        ac.addOperator(operator);
    }

    /// only the owner can call ownerAction
    function testFuzz_RandomCallerCannotCallOwnerAction(address caller) external {
        vm.assume(caller != owner);
        vm.assume(caller != address(0));
        vm.prank(caller);
        vm.expectRevert("not owner");
        ac.ownerAction();
    }

    /// only operators can call operatorAction
    function testFuzz_RandomCallerCannotCallOperatorAction(address caller) external {
        vm.assume(caller != operator);
        vm.assume(caller != owner); // owner isn't auto-operator in this contract
        vm.assume(caller != address(0));
        vm.prank(caller);
        vm.expectRevert("not operator");
        ac.operatorAction();
    }

    /// anyone (except zero address) can call publicAction
    function testFuzz_AnyoneCanCallPublicAction(address caller) external {
        vm.assume(caller != address(0));
        vm.prank(caller);
        ac.publicAction(); // should not revert
    }

    /// owner can add and remove operators
    function testFuzz_OwnerOperatorManagement(address op) external {
        vm.assume(op != address(0));
        vm.assume(op != owner);

        vm.prank(owner);
        ac.addOperator(op);
        assertTrue(ac.operators(op));

        vm.prank(owner);
        ac.removeOperator(op);
        assertFalse(ac.operators(op));
    }
}
