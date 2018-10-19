pragma solidity ^0.4.24;
contract King
{
  address owner;
  
  address public addressOfKing;
  string public nameOfCurrentKing;
  uint256 public currentBid = 0 finney;
  uint56 public constant minimumBid = 15 finney;
  uint56 constant commision = 10 finney;
  uint56 constant upkeep = 2 finney;

  constructor() public { owner = msg.sender; addressOfKing = msg.sender; }

  function startThrone(string name) payable public
  {
      //Make sure player trying to bid places at least the minimum bid
      require(msg.value >= currentBid + minimumBid, "Minimum bid not met");
      
      //Check balance to make sure overdrawing balance doesn't happen
      require(address(this).balance >= commision + currentBid, "Balance will be overdrawn");
      
      //Transfer new bid to current King
      addressOfKing.transfer(msg.value - commision);
      //Transfer commision to contract owner
      owner.transfer(commision - upkeep);
      
      //Set current King by address and name, and set the bid they placed
      addressOfKing = msg.sender;
      nameOfCurrentKing = name;
      currentBid = msg.value;
  }
  
  function kill() public
  {
      require(msg.sender == owner, "Sender is not the owner");
      owner.transfer(address(this).balance);
      selfdestruct(owner);
  }
}