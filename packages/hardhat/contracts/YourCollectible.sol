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
    string internal currentTokenURI;

    bytes32 internal keyHash;
    uint256 internal fee;
    address internal ownerAddress;
    bool public isSpawning;
    uint256 public result;
    address public resultAddress;

    // string[] public debugStrings;

    enum BattleWinner {
        WAR1,
        WAR2,
        TIE
    }

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
        isSpawning = false;
        ownerAddress = 0x82C0eC5A84C5487F57B1d6386C0002e8e253910c;
    }

    event requestedCollectible(bytes32 indexed requestId);

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(bytes32 => uint256) public requestIdToTokenId;

    //this marks an item in IPFS as "forsale"
    mapping(bytes32 => bool) public forSale;

    //this marks an item in IPFS as "forbattle"
    mapping(uint256 => bool) public forBattle;

    //this lets you look up a token by the uri (assuming there is only one of each uri for now)
    // mapping(bytes32 => uint256) public uriToTokenId;

    mapping(uint256 => address) public tokenIdToOwnerAddress;

    struct Stats {
        uint8 strength;
        uint8 intelligence;
        uint8 endurance;
        uint8 charisma;
        uint8 luck;
    }

    mapping(uint256 => Stats) public tokenIdToStats;

    uint256 public tokenIdsForBattleAmount;
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

    function setOwner(string memory newOwner) public {
        // require(addressToString(msg.sender) == ownerAddress, "NOT OWNER");
        // ownerAddress = newOwner;
    }

    /**
     * Requests randomness from sender address seed
     */
    function createCollectible(string memory tokenURI)
        public
        returns (bytes32 requestId)
    {
        isSpawning = true;
        uint256 seed = uint256(msg.sender);
        bytes32 requestId = requestRandomness(keyHash, fee, seed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    function beginBattleArenaProcess() public {
        // require(addressToString(msg.sender) == ownerAddress, "NOT OWNER");
        isSpawning = false;

        uint256 seed = uint256(msg.sender);
        bytes32 requestId = requestRandomness(keyHash, fee, seed);
        requestIdToSender[requestId] = msg.sender;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness)
        internal
        override
    {
        // require(requestIdToSender[requestId] != 0, "NO RAND REQUEST");
        address owner = requestIdToSender[requestId];

        // if sender is the contract, do battle!

        if (!isSpawning) {
            // debugStrings.push("got past the isSpawning check");
            startBattleArena(randomness);
        } else {
            string memory tokenURI = requestIdToTokenURI[requestId];

            uint256 newItemId = tokenCounter;
            uint256[] memory randomNumbers = expand(randomness, 5);
            tokenIdToStats[newItemId].strength = uint8(
                (randomNumbers[0] % 100) + 1
            );
            tokenIdToStats[newItemId].intelligence = uint8(
                (randomNumbers[1] % 100) + 1
            );
            tokenIdToStats[newItemId].endurance = uint8(
                (randomNumbers[2] % 100) + 1
            );
            tokenIdToStats[newItemId].charisma = uint8(
                (randomNumbers[3] % 100) + 1
            );
            tokenIdToStats[newItemId].luck = uint8(
                (randomNumbers[4] % 100) + 1
            );

            bytes32 uriHash = keccak256(abi.encodePacked(tokenURI));

            //make sure they are only minting something that is marked "forsale"
            require(forSale[uriHash], "NOT FOR SALE");
            forSale[uriHash] = false;

            _safeMint(owner, newItemId);
            _setTokenURI(newItemId, tokenURI);

            tokenIdToOwnerAddress[newItemId] = owner;
            forBattle[newItemId] = false;
            requestIdToTokenId[requestId] = newItemId;
            tokenCounter++;
        }
    }

    /**
     * Put the token on the battle list!
     */
    function enlistForBattle(uint256 tokenId) public payable {
        require(forBattle[tokenId] == false, "WARRIOR ALREADY ENLISTED");
        require(msg.value == 50000000000000000, "INCORRECT ETHER AMOUNT SENT");

        bool inBattleArray = false;
        for (uint256 j = 0; j < tokenIdsForBattle.length; j++) {
            if (tokenIdsForBattle[j] == tokenId) {
                inBattleArray = true;
            }
        }
        if (!inBattleArray) {
            tokenIdsForBattle.push(tokenId);
            tokenIdsForBattleAmount = tokenIdsForBattle.length;
            forBattle[tokenId] = true;
        }
        tokenIdToOwnerAddress[tokenId] = msg.sender;
    }

    /**
     * Start and manage the battle arena!
     */
    function startBattleArena(uint256 randomness) public {
        require(tokenIdsForBattleAmount > 1, "NOT ENOUGH BATTLE TOKENS");
        uint256 randomNumbersLength = tokenIdsForBattleAmount + 3;
        uint256[] memory randomNumbers = expand(
            randomness,
            randomNumbersLength
        );
        uint256[3] memory randomStatIndexes = [
            randomNumbers[randomNumbersLength - 1] % 5,
            randomNumbers[randomNumbersLength - 2] % 5,
            randomNumbers[randomNumbersLength - 3] % 5
        ];
        uint256 res = battle(
            tokenIdsForBattle[0],
            tokenIdsForBattle[1],
            randomStatIndexes
        );

        result = res;
        if (res > 0) {
            (bool success, ) = tokenIdToOwnerAddress[0].call{
                value: 90000000000000000
            }("");
            require(success, "Transfer failed.");
            resultAddress = tokenIdToOwnerAddress[0];
        } else if (res < 0) {
            (bool success, ) = tokenIdToOwnerAddress[1].call{
                value: 90000000000000000
            }("");
            require(success, "Transfer failed.");
            resultAddress = tokenIdToOwnerAddress[1];
        } else {
            /*
            payable(tokenIdToOwnerAddress[0]).transfer(250000000000000000);
            payable(tokenIdToOwnerAddress[1]).transfer(250000000000000000);
            */
            resultAddress = address(this);
        }

        for (uint256 i = 0; i < tokenIdsForBattleAmount; i + 2) {
            if (tokenIdsForBattleAmount > i + 1) {
                forBattle[tokenIdsForBattle[i + 1]] = false;

                res = battle(
                    tokenIdsForBattle[i],
                    tokenIdsForBattle[i + 1],
                    randomStatIndexes
                );
            }
            forBattle[tokenIdsForBattle[i]] = false;
        }

        /*
        delete tokenIdsForBattle;
        // debugStrings.push("got to the very end! :)");
        for (uint256 i = 0; i < tokenIdsForBattleAmount; i++) {
            forBattle[tokenIdsForBattle[i]] = false;
        }
        // delete tokenIdsForBattle;
        */

        for (uint256 i = 0; i < tokenIdsForBattleAmount; i++) {
            forBattle[tokenIdsForBattle[i]] = false;
        }
        tokenIdsForBattleAmount = 0;
        tokenIdsForBattle = new uint256[](0);
    }

    function battle(
        uint256 warrior1TokenId,
        uint256 warrior2TokenId,
        uint256[3] memory statMatchups
    ) internal returns (uint256 result) {
        // run a for-loop where we compare different stats against each other
        BattleWinner res;
        uint256 battleNum = 0;
        uint256 statsMatchupsLength = 3;
        for (uint256 i = 0; i < statsMatchupsLength; i++) {
            // if (battleNum == 2) return battleNum;
            //if (battleNum == -2) return battleNum;
            if (statMatchups[i] == 0) {
                res = compareStat(
                    tokenIdToStats[warrior1TokenId].strength,
                    tokenIdToStats[warrior2TokenId].strength
                );
            } else if (statMatchups[i] == 1) {
                res = compareStat(
                    tokenIdToStats[warrior1TokenId].intelligence,
                    tokenIdToStats[warrior2TokenId].intelligence
                );
            } else if (statMatchups[i] == 2) {
                res = compareStat(
                    tokenIdToStats[warrior1TokenId].endurance,
                    tokenIdToStats[warrior2TokenId].endurance
                );
            } else if (statMatchups[i] == 3) {
                res = compareStat(
                    tokenIdToStats[warrior1TokenId].charisma,
                    tokenIdToStats[warrior2TokenId].charisma
                );
            } else if (statMatchups[i] == 4) {
                res = compareStat(
                    tokenIdToStats[warrior1TokenId].luck,
                    tokenIdToStats[warrior2TokenId].luck
                );
            }

            if (res == BattleWinner.WAR1) battleNum += 1;
            else if (res == BattleWinner.WAR2) battleNum -= 1;
        }
        return battleNum;
    }

    function compareStat(uint256 warrior1Stat, uint256 warrior2Stat)
        internal
        pure
        returns (BattleWinner result)
    {
        if (warrior1Stat > warrior2Stat) return BattleWinner.WAR1;
        else if (warrior1Stat < warrior2Stat) return BattleWinner.WAR2;
        return BattleWinner.TIE;
    }
}
