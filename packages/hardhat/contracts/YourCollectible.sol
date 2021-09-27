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
    address public resultAddress;

    // string[] public debugStrings;

    enum ContractState {
        SPAWNING,
        BATTLING
    }

    ContractState public CurrentContractState;

    enum BattleWinner {
        WAR1,
        WAR2,
        TIE
    }

    BattleWinner public result;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public tokenCounter;
    uint256[] public championTokens = new uint256[](1);

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
        ownerAddress = 0x82C0eC5A84C5487F57B1d6386C0002e8e253910c;
    }

    event requestedCollectible(bytes32 indexed requestId);
    event enlistChange();

    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(bytes32 => uint256) public requestIdToTokenId;

    //this marks an item in IPFS as "forsale"
    mapping(bytes32 => bool) public forSale;

    mapping(uint256 => bool) public forBattle;
    uint256 private BATTLECOST = 700000; // normally 50000000000000000

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
        CurrentContractState = ContractState.SPAWNING;
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
        // require(requestIdToSender[requestId] != 0, "NO RAND REQUEST");
        address owner = requestIdToSender[requestId];
        // if sender is the contract, do battle!

        if (CurrentContractState == ContractState.BATTLING) {
            startBattle(randomness, requestIdToTokenId[requestId]);
        } else if (CurrentContractState == ContractState.SPAWNING) {
            string memory tokenURI = requestIdToTokenURI[requestId];

            uint256 newItemId = tokenCounter + 1;
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
        require(msg.value == BATTLECOST, "INCORRECT ETHER AMOUNT SENT");

        uint256 championTokenAmount = championTokens.length;
        // first check if any of the spots are open
        if (championTokens[0] == 0) {
            championTokens[0] = tokenId;
            forBattle[tokenId] = true;
            emit enlistChange();
            return;
        }

        tokenIdToOwnerAddress[tokenId] = msg.sender;
        // require(addressToString(msg.sender) == ownerAddress, "NOT OWNER");
        CurrentContractState = ContractState.BATTLING;
        uint256 seed = uint256(msg.sender);
        bytes32 requestId = requestRandomness(keyHash, fee, seed);
        requestIdToSender[requestId] = msg.sender;
        forBattle[tokenId] = true;
        emit enlistChange();
    }

    /**
     * Start and manage the battle arena!
     */
    function startBattle(uint256 randomness, uint256 userWarriorTokenId)
        public
    {
        uint256 randomNumbersLength = 4;
        uint256[] memory randomNumbers = expand(
            randomness,
            randomNumbersLength
        );
        uint256[3] memory randomStatIndexes = [
            randomNumbers[randomNumbersLength - 1] % 5,
            randomNumbers[randomNumbersLength - 2] % 5,
            randomNumbers[randomNumbersLength - 3] % 5
        ];

        uint256 championTokenAmount = championTokens.length;
        uint256 championOpponentToken = randomNumbers[randomNumbersLength - 4] %
            championTokenAmount;

        BattleWinner res = battle(
            userWarriorTokenId,
            championOpponentToken,
            randomStatIndexes
        );
        result = res;

        if (res == BattleWinner.WAR1) {
            (bool success, ) = tokenIdToOwnerAddress[userWarriorTokenId].call{
                value: ((BATTLECOST * 2) * 9) / 10
            }("");
            require(success, "Transfer failed.");
            resultAddress = tokenIdToOwnerAddress[userWarriorTokenId];
            forBattle[championOpponentToken] = false;
            championOpponentToken = userWarriorTokenId;
        } else if (res == BattleWinner.WAR2) {
            (bool success, ) = tokenIdToOwnerAddress[championOpponentToken]
                .call{value: ((BATTLECOST * 2) * 9) / 10}("");
            require(success, "Transfer failed.");
            resultAddress = tokenIdToOwnerAddress[championOpponentToken];
            forBattle[userWarriorTokenId] = false;
        } else {
            // payable(tokenIdToOwnerAddress[0]).transfer(250000000000000000);
            // payable(tokenIdToOwnerAddress[1]).transfer(250000000000000000);
            resultAddress = address(this);
        }
        emit enlistChange();
    }

    function battle(
        uint256 warrior1TokenId,
        uint256 warrior2TokenId,
        uint256[3] memory statMatchups
    ) internal returns (BattleWinner result) {
        // run a for-loop where we compare different stats against each other
        BattleWinner res;
        uint256 warrior1Wins = 0;
        uint256 warrior2Wins = 0;
        uint256 statsMatchupsLength = 3;
        for (uint256 i = 0; i < statsMatchupsLength; i++) {
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

            if (res == BattleWinner.WAR1) warrior1Wins += 1;
            else if (res == BattleWinner.WAR2) warrior2Wins += 1;
        }

        BattleWinner winner;
        if (warrior1Wins > warrior2Wins) winner = BattleWinner.WAR1;
        else if (warrior1Wins < warrior2Wins) winner = BattleWinner.WAR2;
        else winner = BattleWinner.TIE;
        return winner;
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

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawMoney() public {
        require(msg.sender == ownerAddress, "NOT OWNER");
        address payable to = payable(msg.sender);
        to.transfer(getBalance());
    }
}
