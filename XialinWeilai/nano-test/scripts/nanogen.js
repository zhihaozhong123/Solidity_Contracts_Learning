const hre = require("hardhat");

// nextgen
const nextgenAB = require("../artifacts/contracts/NextGen.sol/NextGen.json");

/*
* on sepolia network
*
* */
async function migrateNextGen() {
    /*
     *
     * 部署nextGen合约
     *
     * */
    const nextgen = await hre.ethers.getContractFactory(nextgenAB.abi, nextgenAB.bytecode);
    const nextgen_deploy = (await nextgen.deploy());
    await nextgen_deploy.deployed();
    let nextgenContract = await nextgen_deploy.address;
    console.log("nextgenContract deployed to:" + nextgenContract + "\n");
    return nextgenContract;
}
migrateNextGen()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

module.exports = {
    migrateNextGen
}