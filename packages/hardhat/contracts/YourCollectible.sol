pragma solidity >=0.6.0 <0.7.0;
//SPDX-License-Identifier: MIT

//import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
//learn more: https://docs.openzeppelin.com/contracts/3.x/erc721

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721, VRFConsumerBase {

  bytes32 internal keyHash;
  uint256 internal fee;

  uint256 public randomResultStrength;
  uint256 public randomResultIntelligence;
  uint256 public randomResultEndurance;
  uint256 public randomResultCharisma;
  uint256 public randomResultLuck;

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor(bytes32[] memory assetsForSale) public 
    VRFConsumerBase(
      0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
      0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
    ) ERC721("YourCollectible", "YCB") {  
    _setBaseURI("https://ipfs.io/ipfs/");
    for(uint256 i=0;i<assetsForSale.length;i++){
      forSale[assetsForSale[i]] = true;
    }
    keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
    fee = 0.1 * 10 ** 18; // 0.1 LINK
  }

  //this marks an item in IPFS as "forsale"
  mapping (bytes32 => bool) public forSale;

  //this lets you look up a token by the uri (assuming there is only one of each uri for now)
  mapping (bytes32 => uint256) public uriToTokenId;

  // strength
  mapping (bytes32 => uint8) public tokenStrength;
  // intelligence
  mapping (bytes32 => uint8) public tokenIntelligence;
  // endurance
  mapping (bytes32 => uint8) public tokenEndurance;
  // charisma
  mapping (bytes32 => uint8) public tokenCharisma;
  // luck
  mapping (bytes32 => uint8) public tokenLuck;

  uint256[] public tokenIdsForBattle;
  
    function expand(uint256 randomValue, uint256 n) public pure returns (uint256[] memory expandedValues) {
        expandedValues = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            expandedValues[i] = uint256(keccak256(abi.encode(randomValue, i)));
        }
        return expandedValues;
    }

   /** 
    * Requests randomness from a user-provided seed
    */
    function getRandomNumber(uint256 userProvidedSeed) public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee, userProvidedSeed);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256[] memory randomNumbers = expand(randomness, 5);
        randomResultStrength = randomNumbers[0];
        randomResultIntelligence = randomNumbers[1];
        randomResultEndurance = randomNumbers[2];
        randomResultCharisma = randomNumbers[3];
        randomResultLuck= randomNumbers[4];
    }

    /**
     * Put the token on the battle list!
     */
    function enlistForBattle(uint256 tokenId) public {  
      bool inBattleArray = false;
      for (uint j = 0; j < tokenIdsForBattle.length; j++) {
        if (tokenIdsForBattle[j] == tokenId) {
          inBattleArray = true;
        }
      }
      if (!inBattleArray) {
        tokenIdsForBattle.push(tokenId);
      }
    }

    /**
     * Start the battle
     */
    function startBattling() public {  
      for (uint j = 0; j < tokenIdsForBattle.length; j+=2) {
        string memory firstTokenURI = tokenURI(tokenIdsForBattle[j]);
        bytes32  firstURIHash = keccak256(abi.encodePacked(firstTokenURI));
        string memory secondTokenURI = tokenURI(tokenIdsForBattle[j+1]);
        bytes32 secondURIHash = keccak256(abi.encodePacked(secondTokenURI));
        /*
        if (tokenStrength[firstURIHash] > tokenStrength[secondURIHash]) {
        }
        else if (tokenStrength[firstURIHash] < tokenStrength[secondURIHash]) {
        }
        */
      }
      // randomly pair NFT's with each other
      // randomly select one of the 5 skills
      // compare them and award the winner to be the higher

      // after all battles have taken place, delete array
      delete tokenIdsForBattle;
    }

  function mintItem(string memory tokenURI)
      public
      returns (uint256)
  {
      bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));

      //make sure they are only minting something that is marked "forsale"
      require(forSale[uriHash],"NOT FOR SALE");
      forSale[uriHash]=false;

      tokenStrength[uriHash] = uint8((randomResultStrength % 100) + 1);
      tokenIntelligence[uriHash] = uint8((randomResultIntelligence % 100) + 1);
      tokenEndurance[uriHash] = uint8((randomResultEndurance % 100) + 1);
      tokenCharisma[uriHash] = uint8((randomResultCharisma % 100) + 1);
      tokenLuck[uriHash] = uint8((randomResultLuck % 100) + 1);

      randomResultStrength = 0;
      randomResultIntelligence = 0;
      randomResultEndurance = 0;
      randomResultCharisma = 0;
      randomResultLuck = 0;

      _tokenIds.increment();

      uint256 id = _tokenIds.current();
      _mint(msg.sender, id);
      _setTokenURI(id, tokenURI);

      uriToTokenId[uriHash] = id;

      return id;
  }
}
