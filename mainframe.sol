pragma solidity 0.6.12; 

import "./ownable.sol";

contract mainframe{ 
  uint public nodecount = 0; 
  bytes32 authorHash;
  event newPaper(uint paperOwnerId, string paperTitle, bytes32 paperHash);
  
  struct User{ 
    uint userId; 
    string userName; 
    address userAddress;
    bool author;   //true = user is author, vice versa
  }

   struct Paper{ 
    uint paperOwnerId;
    uint paperCost;
    string paperTitle; 
    bytes32 paperHash;
  }
  
  mapping (uint => address) public userToAddress;

  mapping (uint => address[]) paperToAddress;
  mapping (address => uint[]) public ownerToPapers;
  

  //mapping (uint => uint) public ownerIdToPaper; 

  User[] public users; //dynamic array of users
  Paper[] public papers; //dynamic array of papers

  modifier isAuthor(uint _userId){   //check whether user is author 
    require(users[_userId].author == true); 
    _; 
  }
  
  modifier isOwner(uint _userId){   //check whether user is owner
  require(msg.sender == users[_userId].userAddress);
    _;
  }
  

  function uploadPaper(uint _paperOwnerId, uint _paperCost ether, string memory _paperTitle) external{ 
    bytes32 hashDummy = keccak256(abi.encodePacked(getRandomNumber()));
    papers.push(Paper(_paperOwnerId, _paperCost, _paperTitle,hashDummy));
    uint paperInd = papers.length - 1;
    bytes32 realHash = callPaperHash(paperInd);
    papers[paperInd].paperHash = realHash;
    paperToAddress[paperInd].push(msg.sender);
    ownerToPapers[msg.sender].push(paperInd);
    emit newPaper(_paperOwnerId, _paperTitle, realHash);
  }
  
  
 function callPaperHash(uint id) internal pure returns (bytes32){
   return keccak256(abi.encodePacked(getRandomNumber(), id));
 }

function queryPaper(uint _index) external view returns(bytes32) {
    address[] memory addressList = paperToAddress[_index];
    for (uint i = 0; i < addressList.length; i++){
        if (addressList[i] == msg.sender){
            return papers[_index].paperHash;
            break;
        }
    }

    revert("Doesn't own paper");

}
  
}



  /*
  function uploadPaper(address _owner, uint _paperOwnerId, string memory _paperTitle, bytes32 _paperHash) internal isAuthor(_paperOwnerId){ 
    uint paperInd = papers.push(Paper(_paperOwnerId, _paperTitle, _paperHash)) - 1;
    paperToAddress[paperInd] = msg.sender;
    ownerToPapers[_owner].push(paperInd);
    emit newPaper(paperInd, _paperOwnerId, _paperTitle, _paperHash);
  }

 // function callPaperHash() internal return (bytes32){
    

  //function addUser(){} //concept: add user to user array

    
  } //concept: gets paper hash
 


  //ownerToPapers[owner];

*/


   
