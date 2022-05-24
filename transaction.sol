pragma solidity 0.6.12; 

import "./mainframe.sol"; 

contract transaction is mainframe{ 

  event transaction(address sender, address receiver, uint amount);

  
  modifier checkBalance(uint amountTransferred, uint userBalance){ 
    require(amountTransferred <= userBalance); 
    _; 
  } //check whether the user have enough balance for the transaction

  
  function transferETH(address payable _receiverAddress, uint _amount)public payable { 
    address senderAddress = msg.sender; 
    _receiverAddress.transfer(_amount); 
  }           

  
   //Checks if the money sent and then gives the user address the owner of the paper from ownerToPapers, as well as have paperToAddress give the paperId to the user address. | Needs more implementation on how the hash is going to return a copy of the paper.
  function buyPaper(uint _paperInd, address payable _receiver) external payable{
    Paper memory targetPaper = papers[_paperInd];
    require(msg.value == targetPaper.paperCost);
    ownerToPapers[msg.sender].push(_paperInd);
    paperToAddress[_paperInd].push(msg.sender);
    
  } 


  
}
//  mapping (address => uint[]) public ownerToPapers;
//     ownerToPapers[_owner].push(paperInd);

contract ETHReceiver{ 
  event Log(uint amount, uint gas); 

  receive() external payable { 
    emit Log(msg.value, gasleft()); 
  }
}
