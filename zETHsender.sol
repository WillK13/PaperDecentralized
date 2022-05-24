pragma solidity 0.6.12; 

import "./mainframe.sol"; 

contract ETHsender is mainframe{ 

  event transaction(address sender, address receiver, uint amount);
        address owner;
        
        constructor() public{
        owner = msg.sender;
    }

  function transferETH(address payable _receiverAddress)external payable { 
    uint amount = msg.value; 
    _receiverAddress.transfer(amount); 
  }
}


//THIS SHIT FINALY WORKS!!!!!!!!
//send eth to another address