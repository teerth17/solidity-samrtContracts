// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LCM {

    //this function calculates the LCM
    function gcd(uint a,uint b) internal pure returns(uint){
        while(b != 0){
            uint temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    function lcm(uint a, uint b) public pure returns (uint) {
        return (a*b)/gcd(a,b);
    }

}
