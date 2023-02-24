
const hre = require("hardhat");
const hardhatConfig = require("../hardhat.config");


async function main() { 

const [owner] = await ethers.getSigners();
const SampleAccountTest = await hre.ethers.getContractFactory("SampleAccount");
const sampleAccountTest = await SampleAccountTest.connect(owner).deploy();
await sampleAccountTest.deployed();

  console.log(
    `Contract deployed to ${sampleAccountTest.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});