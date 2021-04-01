pragma solidity ^0.5.0;

import "./ERC721Full.sol";

contract MNFTH is ERC721Full {
  using SafeMath for uint256;
  string[] public colors;
  mapping(string => bool) _colorExists;

  //ID of pixels created
  using Counters for Counters.Counter;
  Counters.Counter private _pixelIdTracker;

  address public _writer;
  mapping (uint256 => address) internal owners;
  mapping (address => uint256) internal balances;
  uint256 internal maxId;
  //mapping (uint256 => bool) internal burned;

  uint256 _initialSupply = 1000000;

  constructor()ERC721Full("Million NFT Home Page", "MNFTH") public { //this somehow worked lol
      _writer = msg.sender; //Owner of the contract is the one who deploys it
      
      balances[msg.sender] = _initialSupply; //Set contract owner to all initial tokens
      
      maxId = _initialSupply; //Set maxId to number of tokens

      //_supportedInterfaces[this.balanceOf.selector ^ this.ownerOf.selector]
  }

  function isValidToken(uint256 _tokenId) internal view returns(bool){
      return _tokenId != 0 && _tokenId <= maxId;
  }

   function balanceOf(address _owner) public view returns (uint256){
       return balances[_owner];
   }

  function ownerOf(uint256 _tokenId) public view returns(address){
      require(isValidToken(_tokenId));
      if(owners[_tokenId] != _writer){
          return owners[_tokenId];
      }else{
          return _writer;
      }
  }

  function initialDistribution() private {
      require(balances[msg.sender] < 5); //only people with less than 5 tokens can mint FIX ME
      balances[msg.sender] = balances[msg.sender].add(1); //setting to 1 as an example FIX ME
      emit Transfer(_writer, msg.sender, 1); //emit transfer of token

  }

   // E.G. color = "#FFFFFF"
  function mint(string memory _color) public {
    require(!_colorExists[_color]);
    uint _id = colors.push(_color);
    _mint(msg.sender, _id); 
    _colorExists[_color] = true;
  }

//   function setColor(string memory _color, uint256 _tokenID) public {
//     //require(_tokenID.owner == msg.sender);

//     _tokenID.color = _color;
//   }
}
