// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

contract EventOrganization{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemaining;
         
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date > block.timestamp,"You can organize event for future dates");
        require(ticketCount>0,"Create more than 100 tickets");
        
        events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"There is no such event");
        require(events[id].date>block.timestamp,"Event has been passed");
        Event storage _event = events[id];
        require(msg.value==(_event.price*quantity),"Ether is not appropriate");
        require(_event.ticketRemaining>=quantity,"not enough tickets");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+=quantity;
         

    }
    function ticketLeft(uint id) public view returns(uint){
        Event storage _event = events[id];
        return _event.ticketRemaining;
    } 
    function tansferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"There is no such event");
        require(events[id].date>block.timestamp,"Event has been passed");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }

}
