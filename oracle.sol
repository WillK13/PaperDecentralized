pragma solidity 0.6.12;
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract Random is VRFConsumerbase {

    bytes32 public keyHash;
    uint256 public fee;
    uint256 public randomResult;

    struct paper {
        string name;
        uint price;
    }

    paper[] public papers;

    constructor() VRFConsumerBase(
        0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF stuff
        0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // no clue but stack overflow said I needed it
    ) public{
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311; //from import
        fee = 100000000000000000; //change whenever

    }

    function _createPaper(string memory _name, uint _price) private {
        papers.push(Paper(_name, _price));
    }


    function getRandomNumber() public returns (bytes32 requestId) {
        return requestRandomness(keyHash, fee);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

}