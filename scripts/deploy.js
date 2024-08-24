const { ethers } = require("hardhat");
const dotenv = require("dotenv");

dotenv.config();

async function main() {
    // Obtener los contratos
    const JesusCrypt = await ethers.getContractFactory("JesusCrypt");
    const JesusCryptPresale = await ethers.getContractFactory("JesusCryptPresale");
    const JesusCryptAdvisors = await ethers.getContractFactory("JesusCryptAdvisors");
    const JesusCryptLiquidityLocker = await ethers.getContractFactory("JesusCryptLiquidityLocker");

    // Desplegar el contrato JesusCrypt
    const jesusCryptInstance = await JesusCrypt.deploy();
    await jesusCryptInstance.deployed();
    console.log("JesusCrypt deployed to:", jesusCryptInstance.address);

    // Desplegar el contrato JesusCryptPresale pasando la dirección del contrato JesusCrypt
    const jesusCryptPresaleInstance = await JesusCryptPresale.deploy(jesusCryptInstance.address);
    await jesusCryptPresaleInstance.deployed();
    console.log("JesusCryptPresale deployed to:", jesusCryptPresaleInstance.address);

    // Desplegar el contrato JesusCryptAdvisors pasando la dirección del contrato JesusCrypt
    const jesusCryptAdvisorsInstance = await JesusCryptAdvisors.deploy(jesusCryptInstance.address);
    await jesusCryptAdvisorsInstance.deployed();
    console.log("JesusCryptAdvisors deployed to:", jesusCryptAdvisorsInstance.address);

    // Desplegar el contrato JesusCryptLiquidityLocker pasando la dirección del contrato JesusCrypt
    const jesusCryptLiquidityLockerInstance = await JesusCryptLiquidityLocker.deploy(jesusCryptInstance.address);
    await jesusCryptLiquidityLockerInstance.deployed();
    console.log("JesusCryptLiquidityLocker deployed to:", jesusCryptLiquidityLockerInstance.address);

    // Actualizar el contrato JesusCrypt con la dirección del contrato JesusCryptPresale
    await jesusCryptInstance.setAdvisors(jesusCryptAdvisorsInstance.address);
    await jesusCryptInstance.setPresale(jesusCryptPresaleInstance.address);
    await jesusCryptPresaleInstance.setPancakeSwapPositionManager(process.env.POSITION_MANAGER_ADDRESS);
    await jesusCryptPresaleInstance.setLiquidityLocker(jesusCryptLiquidityLockerInstance.address);

    console.log("Contracts have been set up successfully.");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
