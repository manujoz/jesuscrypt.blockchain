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

    // Get the contract factories
    const JesusCrypt = await ethers.getContractFactory("JesusCrypt");
    const JesusCryptPresale = await ethers.getContractFactory("JesusCryptPresale");
    const JesusCryptAdvisors = await ethers.getContractFactory("JesusCryptAdvisors");
    const JesusCryptLiquidityLocker = await ethers.getContractFactory("JesusCryptLiquidityLocker");

    // Deploy the JesusCrypt contract
    const jesusCryptInstance = await JesusCrypt.deploy();
    await jesusCryptInstance.deployed();
    console.log("JesusCrypt deployed to:", jesusCryptInstance.address);

    // Deploy the JesusCryptPresale contract passing the JesusCrypt contract address
    const jesusCryptPresaleInstance = await JesusCryptPresale.deploy(jesusCryptInstance.address);
    await jesusCryptPresaleInstance.deployed();
    console.log("JesusCryptPresale deployed to:", jesusCryptPresaleInstance.address);

    // Deploy the JesusCryptAdvisors contract passing the JesusCrypt contract address
    const jesusCryptAdvisorsInstance = await JesusCryptAdvisors.deploy(jesusCryptInstance.address);
    await jesusCryptAdvisorsInstance.deployed();
    console.log("JesusCryptAdvisors deployed to:", jesusCryptAdvisorsInstance.address);

    // Deploy the JesusCryptLiquidityLocker contract passing the JesusCrypt contract address
    const jesusCryptLiquidityLockerInstance = await JesusCryptLiquidityLocker.deploy(jesusCryptInstance.address);
    await jesusCryptLiquidityLockerInstance.deployed();
    console.log("JesusCryptLiquidityLocker deployed to:", jesusCryptLiquidityLockerInstance.address);

    // Update the JesusCrypt contract with the JesusCryptPresale contract address
    await jesusCryptInstance.setAdvisors(jesusCryptAdvisorsInstance.address);
    await jesusCryptInstance.setPresale(jesusCryptPresaleInstance.address, DEVELOPERS);
    await jesusCryptPresaleInstance.setPancakeSwapPositionManager(POSITION_MANAGER_ADDRESS);
    await jesusCryptPresaleInstance.setLiquidityLocker(jesusCryptLiquidityLockerInstance.address);

    console.log("Contracts have been set up successfully.");

    return {
        jesusCryptInstance,
        jesusCryptPresaleInstance,
        jesusCryptAdvisorsInstance,
        jesusCryptLiquidityLockerInstance,
    };
}
