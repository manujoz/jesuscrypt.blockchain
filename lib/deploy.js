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

    // Deploy the JesusCryptPresale contract passing the JesusCrypt contract address
    const jesusCryptPresaleInstance = await JesusCryptPresale.deploy(jesusCryptInstance.address, {
        gasLimit: 5000000, // Ajusta este valor según sea necesario
    });
    await jesusCryptPresaleInstance.deployed();

    // Deploy the JesusCryptAdvisors contract passing the JesusCrypt contract address
    const jesusCryptAdvisorsInstance = await JesusCryptAdvisors.deploy(jesusCryptInstance.address, {
        gasLimit: 5000000, // Ajusta este valor según sea necesario
    });
    await jesusCryptAdvisorsInstance.deployed();

    // Deploy the JesusCryptLiquidityLocker contract passing the JesusCrypt contract address
    const jesusCryptLiquidityLockerInstance = await JesusCryptLiquidityLocker.deploy(jesusCryptPresaleInstance.address, {
        gasLimit: 5000000, // Ajusta este valor según sea necesario
    });
    await jesusCryptLiquidityLockerInstance.deployed();

    // Update the JesusCrypt contract with the JesusCryptPresale contract address
    await jesusCryptInstance.setAdvisors(jesusCryptAdvisorsInstance.address);
    await jesusCryptInstance.setPresale(jesusCryptPresaleInstance.address, jesusCryptLiquidityLockerInstance.address, POSITION_MANAGER_ADDRESS, DEVELOPERS);

    return {
        deployer,
        jesusCryptInstance,
        jesusCryptPresaleInstance,
        jesusCryptAdvisorsInstance,
        jesusCryptLiquidityLockerInstance,
    };
}
