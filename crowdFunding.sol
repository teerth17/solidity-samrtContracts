// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract Cf{
    mapping(address=>uint) public contributors;
    address public manager;
    uint minimumContribution;
    uint deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributors;


constructor(uint _target,uint _deadline){

    target = _target;
    deadline = block.timestamp + _deadline;
    minimumContribution = 100 wei;
     manager = msg.sender;

}

struct Request{
    string description;
    address payable recipient;
    uint value;
    bool completed;
    uint noOfVoters;
    mapping(address=>bool) voters; 
}

mapping(uint=>Request) public requests;
uint public noOfRequest;
function sendWei() public payable{
    require(block.timestamp < deadline,"You missed the deadline");
    require(msg.value >= minimumContribution,"Minimum Contribution is 100 wei");

    if(contributors[msg.sender] == 0){
        noOfContributors++;
    }
    contributors[msg.sender]+=msg.value; 
    raisedAmount+=msg.value;
}
function getContractBalance() view public returns(uint){
    require(msg.sender==manager);
    return address(this).balance;
}
function getRefund() public{
    require(contributors[msg.sender] > 0,"You are not eligible for refund");
    require(block.timestamp > deadline && raisedAmount < target,"Your Amoutn has been Locked");

    address payable user = payable(msg.sender);
    user.transfer(contributors[msg.sender]);
}

function sendRequest(string memory _description,address payable _recipient,uint _value) public{
    require(msg.sender==manager,"Only manager can send Request");
    Request storage newRequest = requests[noOfRequest];
    noOfRequest++;
    newRequest.description = _description;
    newRequest.recipient = _recipient;
    newRequest.value = _value;
    newRequest.completed = false;
    newRequest.noOfVoters = 0;
}

function voteRequest(uint _requestNo) public{
    require(contributors[msg.sender] > 0,"You are not eligible for voting");
    Request storage thisRequest = requests[_requestNo];
    require(thisRequest.voters[msg.sender]==false,"You have voted once");
    thisRequest.voters[msg.sender] = true;
    thisRequest.noOfVoters++;
}

function makePayment(uint _requestNo) public{
    require(msg.sender==manager,"Only manager can make payement");  
    Request storage thisRequest = requests[_requestNo];
    require(thisRequest.completed==false,"Payment has been done");
    require(thisRequest.noOfVoters > noOfContributors/2,"You loose on voting");
    thisRequest.recipient.transfer(thisRequest.value);
    thisRequest.completed = true;

}

}

