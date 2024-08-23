const JesusCrypt = artifacts.require("JesusCrypt");
const JesusCryptPresale = artifacts.require("JesusCryptPresale");
const JesusCryptAdvisors = artifacts.require("JesusCryptAdvisors");
const JesusCryptLiquidityLocker = artifacts.require("JesusCryptLiquidityLocker");

const dotenv = require("dotenv");
dotenv.config();

module.exports = async function (deployer) {
    // Desplegar el contrato JesusCrypt
    await deployer.deploy(JesusCrypt);
    const jesusCryptInstance = await JesusCrypt.deployed();

    // Desplegar el contrato JesusCryptPresale pasando la dirección del contrato JesusCrypt
    await deployer.deploy(JesusCryptPresale, jesusCryptInstance.address);
    const jesusCryptPresaleInstance = await JesusCryptPresale.deployed();

    // Desplegar el contrato JesusCryptAdvisors pasando la dirección del contrato JesusCrypt
    await deployer.deploy(JesusCryptAdvisors, jesusCryptInstance.address);
    const jesusCryptAdvisorsInstance = await JesusCryptAdvisors.deployed();

    // Desplegar el contrato JesusCryptLiquidityLocker pasando la dirección del contrato JesusCrypt
    await deployer.deploy(JesusCryptLiquidityLocker, jesusCryptInstance.address);
    const jesusCryptLiquidityLockerInstance = await JesusCryptLiquidityLocker.deployed();

    // Actualizar el contrato JesusCrypt con la dirección del contrato JesusCryptPresale
    await jesusCryptInstance.setAdvisors(jesusCryptAdvisorsInstance.address);
    await jesusCryptInstance.setPresale(jesusCryptPresaleInstance.address);
    await jesusCryptPresaleInstance.setPancakeSwapPositionManager(process.env.POSITION_MANAGER_ADDRESS);
    await jesusCryptPresaleInstance.setLiquidityLocker(jesusCryptLiquidityLockerInstance.address);
};
