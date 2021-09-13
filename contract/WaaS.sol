// SPDX-License-Identifier: MIT
pragma solidity >=0.7;

contract WAAS {
    string public name;
    uint public contentcounter;
    
    struct request{
        address sender;
        string imgURL;
        string imgHash;
        string PublicKeyURL;
        string PublicKeyHash;
    }
    struct result{
        string watermarkURL;
        string watermarkHash;
        uint256 result1;
        uint256 result2;
    }
    
    mapping (address => bool) public authorizer;
    mapping (uint => request) public entry;
    mapping (uint => result) public wmark;
    mapping (uint => uint) public finalEntry;
    
    constructor(string memory _name, address auth1, address auth2) {
        require(msg.sender != auth1 && msg.sender != auth2 && auth1 != auth2);
        name = _name;
        authorizer[msg.sender] = true;
        authorizer[auth1] = true;
        authorizer[auth2] = true;
        contentcounter = 0;
    }
    
    function isAuth(address _adr) private view returns (bool){
        return authorizer[_adr];
    }
    
    function addRequest(string memory _imgURL, string memory _imgHash, string memory _PubKeyURL, string memory _PubKeyHash) public{
        entry[contentcounter].sender = msg.sender;
        entry[contentcounter].imgURL = _imgURL;
        entry[contentcounter].imgHash = _imgHash;
        entry[contentcounter].PublicKeyURL = _PubKeyURL;
        entry[contentcounter].PublicKeyHash = _PubKeyHash;
        contentcounter +=1;
        finalEntry[contentcounter] = 0;
    }
    
    function addWatermark(uint _msgId, string memory _watermarkURL, string memory _watermarkHash, uint256 _result1) public {
        require(isAuth(msg.sender) && finalEntry[_msgId] == 0);
        require(_msgId < contentcounter);
        wmark[_msgId].watermarkURL = _watermarkURL;
        wmark[_msgId].watermarkHash = _watermarkHash;
        wmark[_msgId].result1 = _result1;
        finalEntry[_msgId] = 1;
    }
    
    function finalizeWatermark(uint _msgId, uint256 _result2) public {
        require(msg.sender == entry[_msgId].sender && finalEntry[_msgId] == 1);
        require(wmark[_msgId].result1 == _result2);
        wmark[_msgId].result2 = _result2;
        finalEntry[_msgId] = 2;
    }
}
