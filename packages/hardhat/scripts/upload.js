/* eslint no-use-before-define: "warn" */
const fs = require("fs");
const chalk = require("chalk");
const { config, ethers } = require("hardhat");
const { utils } = require("ethers");
const R = require("ramda");
const ipfsAPI = require('ipfs-http-client');
const ipfs = ipfsAPI({host: 'ipfs.infura.io', port: '5001', protocol: 'https' })

const warriors = [
  { name: "Achilles", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Genghis Khan", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Vlad the Impaler", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Spartacus", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Count Roland", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Attila the Hun", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "William Wallace", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Alaric the Visigoth", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Musashi", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"},
  { name: "Leonidas", image: "https://www.junoware.com/wp-content/uploads/2021/07/soul.svg"} ];
  
const main = async () => {

  let allAssets = {}
  const TOKEN_MINT_AMOUNT = 5;

  console.log("\n\n Loading artwork.json...\n");
  let artwork = JSON.parse(fs.readFileSync("../../artwork.json").toString())
  const warriorUses = new Array(warriors.length);
  warriorUses.fill(0);
  let artworkString = "[";
  for (let i=0; i < TOKEN_MINT_AMOUNT; i++) {
    if (i != 0) artworkString += ",";
    const warriorMetadataNum = parseInt((Math.random() * (warriors.length)), 10) + 0;
    warriorUses[warriorMetadataNum]++;
    const currentNum = warriorUses[warriorMetadataNum];
    artworkString += `{
      "name": "${warriors[warriorMetadataNum].name}${currentNum == 1 ? "" : ` ${currentNum}`}",
      "external_url": "${warriors[warriorMetadataNum].image}",
      "image": "${warriors[warriorMetadataNum].image}"
    }`;
  }
  artworkString += "]";
  artwork = JSON.parse(artworkString.toString());
  for(let a in artwork){
    console.log("  Uploading "+artwork[a].name+"...")
    const stringJSON = JSON.stringify(artwork[a])
    const uploaded = await ipfs.add(stringJSON)
    console.log("   "+artwork[a].name+" ipfs:",uploaded.path)
    allAssets[uploaded.path] = artwork[a]
  }

  console.log("\n Injecting assets into the frontend...")
  const finalAssetFile = "export default "+JSON.stringify(allAssets)+""
  fs.writeFileSync("../react-app/src/assets.js",finalAssetFile)
  fs.writeFileSync("./uploaded.json",JSON.stringify(allAssets))



  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */


  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */


  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */

};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
