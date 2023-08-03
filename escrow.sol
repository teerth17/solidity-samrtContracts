// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    bool public isApproved;

    // Events
    event Approved(uint p1);

    constructor(address _arbiter,address _beneficiary) payable{
        arbiter = _arbiter;
        beneficiary = _beneficiary;
        depositor = msg.sender;
    }

    function approve() external {
        require(msg.sender == arbiter,"Only arbiter can approve");
        isApproved = true;
        uint balance = address(this).balance;
        (bool s,) = beneficiary.call{value: address(this).balance}("");
        require(s);
        emit Approved(balance);
    }
}
