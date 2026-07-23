// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AccessControlled {
    address public owner;
    mapping(address => bool) public operators;

    event Executed(address indexed caller);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "not operator");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addOperator(address op) external onlyOwner {
        operators[op] = true;
    }

    function removeOperator(address op) external onlyOwner {
        operators[op] = false;
    }

    function ownerAction() external onlyOwner {
        emit Executed(msg.sender);
    }

    function operatorAction() external onlyOperator {
        emit Executed(msg.sender);
    }

    function publicAction() external {
        emit Executed(msg.sender);
    }
}
