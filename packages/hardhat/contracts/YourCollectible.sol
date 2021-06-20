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
    enum ContractState {IDLE, BATTLING, MINTING}
    ContractState internal currentState;
    string internal currentTokenURI;

    bytes32 internal keyHash;
    uint256 internal fee;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public tokenCounter;

    constructor(bytes32[] memory assetsForSale)
        public
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK Token
        )
        ERC721("CryptoSouls", "CSL")
    {
        _setBaseURI("https://ipfs.io/ipfs/");
        for (uint256 i = 0; i < assetsForSale.length; i++) {
            forSale[assetsForSale[i]] = true;
        }
        tokenCounter = 0;
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10**18; // 0.1 LINK
        currentState = ContractState.IDLE;
    }

    event requestedCollectible(bytes32 indexed requestId);

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(bytes32 => uint256) public requestIdToTokenId;

    //this marks an item in IPFS as "forsale"
    mapping(bytes32 => bool) public forSale;

    mapping(address => uint256) public randomNums;
    //this lets you look up a token by the uri (assuming there is only one of each uri for now)
    mapping(bytes32 => uint256) public uriToTokenId;

    // strength
    mapping(uint256 => uint8) public tokenIdToStrength;
    // intelligence
    mapping(uint256 => uint8) public tokenIdToIntelligence;
    // endurance
    mapping(uint256 => uint8) public tokenIdToEndurance;
    // charisma
    mapping(uint256 => uint8) public tokenIdToCharisma;
    // luck
    mapping(uint256 => uint8) public tokenIdToLuck;

    uint256[] public tokenIdsForBattle;

    function expand(uint256 randomValue, uint256 n)
        public
        pure
        returns (uint256[] memory expandedValues)
    {
        expandedValues = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            expandedValues[i] = uint256(keccak256(abi.encode(randomValue, i)));
        }
        return expandedValues;
    }

    /**
     * Requests randomness from a user-provided seed
     */
    function createCollectible(string memory tokenURI)
        public
        returns (bytes32 requestId)
    {
        uint256 seed = uint256(msg.sender);
        bytes32 requestId = requestRandomness(keyHash, fee, seed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        // require(randomNums[msg.sender] != 0, "NO RAND");

        //if (currentState == ContractState.MINTING) {
        // randomNums[msg.sender] = randomness;
        address owner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];

        bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));

        //make sure they are only minting something that is marked "forsale"
        require(forSale[uriHash], "NOT FOR SALE");
        forSale[uriHash] = false;

        uint256 newItemId = tokenCounter;
        _safeMint(owner, newItemId);
        _setTokenURI(newItemId, tokenURI);

        requestIdToTokenId[requestId] = newItemId;
        tokenCounter++;

        uint256[] memory randomNumbers = expand(randomness, 5);
        tokenIdToStrength[newItemId] = uint8((randomNumbers[0] % 100) + 1);
        tokenIdToIntelligence[newItemId] = uint8((randomNumbers[1] % 100) + 1);
        tokenIdToEndurance[newItemId] = uint8((randomNumbers[2] % 100) + 1);
        tokenIdToCharisma[newItemId] = uint8((randomNumbers[3] % 100) + 1);
        tokenIdToLuck[newItemId] = uint8((randomNumbers[4] % 100) + 1);

        /*
        _tokenIds.increment();
        uriToTokenId[uriHash] = id;
        */
        // }

        /*
        else if (currentState == ContractState.BATTLING) {
            uint256[] memory randomNumbers =
                expand(randomness, tokenIdsForBattle.length);
            uint256 randomNumbersLength = randomNumbers.length;
            uint256[3] memory randomStatIndexes =
                [
                    randomNumbers[randomNumbersLength - 1] % 5,
                    randomNumbers[randomNumbersLength - 2] % 5,
                    randomNumbers[randomNumbersLength - 3] % 5
                ];
            for (uint256 i = 0; i < tokenIdsForBattle.length; i + 2) {
                if (tokenIdsForBattle.length > i + 1)
                    battle(
                        tokenIdsForBattle[i],
                        tokenIdsForBattle[i + 1],
                        randomStatIndexes
                    );
            }
            delete tokenIdsForBattle;
            currentState = ContractState.IDLE;
        }
        */
    }

    /*
    function battle(
        uint256 warrior1TokenId,
        uint256 warrior2TokenId,
        uint256[3] memory statMatchups
    ) public {
        // get stats for each warrior
        string memory firstTokenURI = tokenURI(warrior1TokenId);
        bytes32 firstURIHash = keccak256(abi.encodePacked(firstTokenURI));
        string memory secondTokenURI = tokenURI(warrior2TokenId);
        bytes32 secondURIHash = keccak256(abi.encodePacked(secondTokenURI));
        // run a for-loop where we compare different stats against each other
        string memory result;
        for (uint256 i = 0; i < statMatchups.length; i++) {
            if (statMatchups[i] == 0) {
                result = compareStat(
                    tokenIdToStrength[firstURIHash],
                    tokenIdToStrength[secondURIHash]
                );
            } else if (statMatchups[i] == 1) {
                result = compareStat(
                    tokenIdToIntelligence[firstURIHash],
                    tokenIdToIntelligence[secondURIHash]
                );
            } else if (statMatchups[i] == 2) {
                result = compareStat(
                    tokenIdToEndurance[firstURIHash],
                    tokenIdToEndurance[secondURIHash]
                );
            } else if (statMatchups[i] == 3) {
                result = compareStat(
                    tokenIdToCharisma[firstURIHash],
                    tokenIdToCharisma[secondURIHash]
                );
            } else if (statMatchups[i] == 4) {
                result = compareStat(
                    tokenIdToLuck[firstURIHash],
                    tokenIdToLuck[secondURIHash]
                );
            }
        }
    }

    function compareStat(uint256 warrior1Stat, uint256 warrior2Stat)
        internal
        returns (string memory result)
    {
        if (warrior1Stat > warrior2Stat) return "warrior1";
        else if (warrior1Stat < warrior2Stat) return "warrior2";
        else return "tie";
    }
    

    /**
     * Put the token on the battle list!
     */
    function enlistForBattle(uint256 tokenId) public {
        bool inBattleArray = false;
        for (uint256 j = 0; j < tokenIdsForBattle.length; j++) {
            if (tokenIdsForBattle[j] == tokenId) {
                inBattleArray = true;
            }
        }
        if (!inBattleArray) {
            tokenIdsForBattle.push(tokenId);
        }
    }

    function startMintingItem(string memory tokenURI)
        public
        returns (bytes32 requestId)
    {
        currentState = ContractState.MINTING;
        return createCollectible(tokenURI);
        /*
      if (currentState == ContractState.IDLE) {
        currentTokenURI = tokenURI;
        currentState = ContractState.MINTING;
        return requestRandomness(keyHash, fee, block.number);      
      }
      */
    }

    /*
    function mintItem(string memory tokenURI) public returns (uint256) {
        // require(randomNums[msg.sender] != 0, "NO RAND");
        bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));

        //make sure they are only minting something that is marked "forsale"
        require(forSale[uriHash], "NOT FOR SALE");
        forSale[uriHash] = false;

        uint256[] memory randomNumbers = expand(randomNums[msg.sender], 5);

        tokenIdToStrength[uriHash] = uint8((randomNumbers[0] % 100) + 1);
        tokenIdToIntelligence[uriHash] = uint8((randomNumbers[1] % 100) + 1);
        tokenIdToEndurance[uriHash] = uint8((randomNumbers[2] % 100) + 1);
        tokenIdToCharisma[uriHash] = uint8((randomNumbers[3] % 100) + 1);
        tokenIdToLuck[uriHash] = uint8((randomNumbers[4] % 100) + 1);

        delete randomNums[msg.sender];

        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(msg.sender, id);
        _setTokenURI(id, tokenURI);

        uriToTokenId[uriHash] = id;
    }
    */
}
