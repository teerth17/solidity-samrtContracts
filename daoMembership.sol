// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOMembership {

    constructor(){
        members[msg.sender] = true;
        totalMember = 1;
    }
    mapping(address => bool) members;
    mapping(address => uint256) applicants;
    mapping(address => mapping(address => bool)) public approvals;
    uint256 totalMember;

    //To apply for membership of DAO
    function applyForEntry() public OnlyApplicant{
       applicants[msg.sender] = 1;
    }
    
    //To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public OnlyMember{
        require(!isMember(_applicant));
        require(!approvals[msg.sender][_applicant]);
        applicants[_applicant] = applicants[_applicant] + (100 / totalMember);
        approvals[msg.sender][_applicant] = true;
        if(applicants[_applicant] > 30){
            members[_applicant] = true;
            totalMember++;
        }
    }

    //To check membership of DAO
    function isMember(address _user) public OnlyMember view returns (bool) {
        return members[_user];
    }

    //To check total number of members of the DAO
    function totalMembers() public OnlyMember view returns (uint256){
        return totalMember;
    }

    modifier OnlyMember(){
        require(members[msg.sender], "Only members can access this");
        _;
    }

    modifier OnlyApplicant(){
        require(!members[msg.sender], "Only applicants can access this");
        require(applicants[msg.sender] != 1, "Only called once");
        _;
    }
}

