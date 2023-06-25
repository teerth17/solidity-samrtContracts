// SPDX-Licence-Identifier:MIT
pragma solidity ^0.8.8;

import "./priceConvertor.sol"; 

error NotOwner();

contract FundMe{
    using priceConvertor for uint256;

    uint256 public constant MINIMUM_USD = 50*1e18;
    address[] public funders;
    mapping(address=>uint256) public amountFunded;
    address public immutable owner;
    constructor(){
        owner = msg.sender;
    }

    function  fund() public payable{
        // require(msg.value>1e18,"Value should be greater than 1 eher");
          // 1e18 = 1*10**18 == 100000000000000000

         require(msg.value.getConversionRate() >= MINIMUM_USD,"Value should be greater than 1 ether");
         funders.push(msg.sender);
         amountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner{
        // require(msg.sender==owner,"Only owner can access this");
        for(uint256 funderIndex=0;funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            amountFunded[funder] = 0;
        }
        funders = new address[](0);
        // call
        (bool callSuccess,)= payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess, "Call failed");

    }
    modifier onlyOwner{
        // require(msg.sender==owner,"Only owner can access this");
        if(msg.sender != owner){
            revert NotOwner();
        }
        _;
    }

    receive() external payable{
        fund();
    }

    fallback() external payable{
        fund();
    }
   

}
