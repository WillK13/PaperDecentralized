pragma solidity 0.6.12; 

import "./ownable.sol";
import "./oracle.sol";

contract mainframe is Random{ 
  bytes32 authorHash;
  event newPaper(uint paperOwnerId, string paperTitle, bytes32 paperHash);
  
  struct User{ //[USELESS]
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
  
  mapping (uint => address) userToAddress;//[USELESS]

  mapping (uint => address[]) paperToAddress;
  mapping (address => uint[]) ownerToPapers;
  
  //*added this
  function getPapersByOwner(address _owner) external view returns (uint[] memory) {
    return ownerToPapers[_owner];
}

  //mapping (uint => uint) public ownerIdToPaper; 

  User[] users; //dynamic array of users
  Paper[] public papers; //dynamic array of papers

  //[USELESS]
  modifier isAuthor(uint _userId){   //check whether user is author 
    require(users[_userId].author == true); 
    _; 
  }
  
  //[USELESS]
  modifier isOwner(uint _userId){   //check whether user is owner
  require(msg.sender == users[_userId].userAddress);
    _;
  }
  
//* getrandomvalue isn't working so "getRandomValue()" will substitute it for now
  function uploadPaper(uint _paperOwnerId, uint _paperCost, string memory _paperTitle) external{ 
    bytes32 hashDummy = keccak256(abi.encodePacked("getRandomNumber()"));
    papers.push(Paper(_paperOwnerId, _paperCost, _paperTitle,hashDummy));
    uint paperInd = papers.length - 1;
    bytes32 realHash = callPaperHash(paperInd);
    papers[paperInd].paperHash = realHash;
    paperToAddress[paperInd].push(msg.sender);
    ownerToPapers[msg.sender].push(paperInd);
    emit newPaper(_paperOwnerId, _paperTitle, realHash);
  }


 function callPaperHash(uint id) internal returns (bytes32){
   return keccak256(abi.encodePacked("getRandomNumber()", id));
 }
//*put require statement
function queryPaper(int _index) external view returns(bytes32) {
    require(_index <= int(papers.length) - 1,"invalid index");    
    address[] memory addressList = paperToAddress[uint(_index)];
    for (uint i = 0; i < addressList.length; i++){
        if (addressList[i] == msg.sender){
            return papers[uint(_index)].paperHash;
            break;
        }
    }

    revert("Doesn't own paper");

}
  
}



