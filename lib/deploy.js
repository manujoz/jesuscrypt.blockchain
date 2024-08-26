import * as dotenv from "dotenv";
// import { ethers } from "hardhat";

import pkg from "hardhat";
const { ethers } = pkg;

dotenv.config();

const POSITION_MANAGER_ADDRESS = process.env.POSITION_MANAGER_ADDRESS;
const DEVELOPERS = process.env.DEVELOPERS ? process.env.DEVELOPERS.split(",") : undefined;

export async function main() {
    if (!POSITION_MANAGER_ADDRESS) {
        throw new Error("POSITION_MANAGER_ADDRESS is not set");
    }

    if (!DEVELOPERS) {
        throw new Error("DEVELOPERS is not set");
    }

    const [deployer] = await ethers.getSigners();

    // Deploy the library
    const JesusCryptUtils = await ethers.getContractFactory("JesusCryptUtils");
    const jesusCryptUtilsInstace = await JesusCryptUtils.deploy();
    await jesusCryptUtilsInstace.deployed();
    console.log("JesusCryptUtils deployed to: ", jesusCryptUtilsInstace.address);

    // Get the contract factories
    const JesusCrypt = await ethers.getContractFactory("JesusCrypt", { libraries: { JesusCryptUtils: jesusCryptUtilsInstace.address } });
    const JesusCryptPresale = await ethers.getContractFactory("JesusCryptPresale", { libraries: { JesusCryptUtils: jesusCryptUtilsInstace.address } });
    const JesusCryptAdvisors = await ethers.getContractFactory("JesusCryptAdvisors");
    const JesusCryptLiquidityLocker = await ethers.getContractFactory("JesusCryptLiquidityLocker");

    // Deploy the JesusCrypt contract
    const jesusCryptInstance = await JesusCrypt.deploy({
        gasLimit: 5000000, // Ajusta este valor según sea necesario
    });
    await jesusCryptInstance.deployed();
    console.log("JesusCrypt deployed to:", jesusCryptInstance.address);

    // Deploy the JesusCryptPresale contract passing the JesusCrypt contract address
    const jesusCryptPresaleInstance = await JesusCryptPresale.deploy(jesusCryptInstance.address, {
        gasLimit: 5000000, // Ajusta este valor según sea necesario
    });
    await jesusCryptPresaleInstance.deployed();
    console.log("JesusCryptPresale deployed to:", jesusCryptPresaleInstance.address);

    // Deploy the JesusCryptAdvisors contract passing the JesusCrypt contract address
    const jesusCryptAdvisorsInstance = await JesusCryptAdvisors.deploy(jesusCryptInstance.address);
    await jesusCryptAdvisorsInstance.deployed();
    console.log("JesusCryptAdvisors deployed to:", jesusCryptAdvisorsInstance.address);

    // Deploy the JesusCryptLiquidityLocker contract passing the JesusCrypt contract address
    const jesusCryptLiquidityLockerInstance = await JesusCryptLiquidityLocker.deploy(jesusCryptPresaleInstance.address);
    await jesusCryptLiquidityLockerInstance.deployed();
    console.log("JesusCryptLiquidityLocker deployed to:", jesusCryptLiquidityLockerInstance.address);

    // Update the JesusCrypt contract with the JesusCryptPresale contract address
    await jesusCryptInstance.setAdvisors(jesusCryptAdvisorsInstance.address);
    await jesusCryptInstance.setPresale(jesusCryptPresaleInstance.address, jesusCryptLiquidityLockerInstance.address, POSITION_MANAGER_ADDRESS, DEVELOPERS);

    console.log("Contracts have been set up successfully.");

    return {
        jesusCryptInstance,
        jesusCryptPresaleInstance,
        jesusCryptAdvisorsInstance,
        jesusCryptLiquidityLockerInstance,
    };
}
