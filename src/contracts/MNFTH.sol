pragma solidity ^0.5.0;

import "./ERC721Full.sol";

contract MNFTH is ERC721Full {
  using SafeMath for uint256;
  //string[] public colors;
  //mapping(string => bool) _colorExists;

  //ID of pixels created
  using Counters for Counters.Counter;
  Counters.Counter private _pixelIdTracker;

  address public _writer;
  mapping (address => uint256) internal balances;
  uint256 internal maxId;
  //mapping (uint256 => bool) internal burned;

  mapping (uint256 => string) public colorArray;

  uint256 _initialSupply = 10000;

  constructor()ERC721Full("Million NFT Home Page", "MNFTH") public { 
      _writer = msg.sender; //Owner of the contract is the one who deploys it
      
      //balances[msg.sender] = _initialSupply; //Set contract owner to all initial tokens
      
      maxId = _initialSupply; //Set maxId to number of tokens

      //_supportedInterfaces[this.balanceOf.selector ^ this.ownerOf.selector]
  }

  function isValidToken(uint256 _tokenId) internal view returns(bool){
      return _tokenId != 0 && _tokenId <= maxId;
  }

  // function initialDistribution() private {
  //     require(balances[msg.sender] < 5); //only people with less than 5 tokens can mint FIX ME
  //     balances[msg.sender] = balances[msg.sender].add(1); //setting to 1 as an example FIX ME
  //     emit Transfer(_writer, msg.sender, 1); //emit transfer of token

  // }

  function mintPixel(uint256 token_id, string memory color) public returns (uint256) { //where tokenURI is json file containing, x coord, y coord, owner, price,
    
    //####### this might not even be needed due to the ERC721 contract already handling this ############
    //function mintPixel(uint256 token_id, address user, string memory tokenURI) public returns (uint256) { //where tokenURI is json file containing, x coord, y coord, owner, price,
    //ERC 721 handles minting tokens that already have an owner, through the require()
    //just need to double check that the rest of the code is using that library
    
    require(isValidToken(token_id), "Invalid token ID"); 
    //validate pixel has not been created before
    //require(ownerOf(token_id) == _writer, "This token is owned by someone, therefore can't be minted");

    //#################### END #############

    //_pixelIdTracker.increment();  //not needed since pixelID will be handled on web client side
    //uint256 newPixelID = _pixelIdTracker.current();
    
    _mint(msg.sender, token_id);
    colorArray[token_id] = color;
    //_setTokenURI(token_id, tokenURI);
    
    //updatePixelMapping() //file read by website for quick load

    return token_id;
  }

  function updatePixelMapping(uint256 token_id, string memory color) public returns (uint256) {
    require(isValidToken(token_id), "Invalid token ID"); 
    require(ownerOf(token_id) == msg.sender, "You do not own this pixel"); 

    //verify color is valid? any security risk?

    colorArray[token_id] = color; //update color on blockchain
    //update token URI? probably

  }

  function readColor(uint256 token_id) public view returns(string memory){
    return colorArray[token_id];
  }

  // function bulkBuyPixels(uint token_id, uint x, uint y) public {
  //   for(uint i=0; i < x;)
  // }
}
