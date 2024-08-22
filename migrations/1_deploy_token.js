const JesusCrypt = artifacts.require("JesusCrypt");

module.exports = function (deployer) {
    deployer.deploy(JesusCrypt);
};

// const JesusCrypt = artifacts.require("JesusCrypt");
// const JesusCryptPresale = artifacts.require("JesusCryptPresale");

// module.exports = async function (deployer) {
//     // Desplegar el contrato JesusCrypt
//     await deployer.deploy(JesusCrypt);
//     const jesusCryptInstance = await JesusCrypt.deployed();

//     // Desplegar el contrato JesusCryptPresale pasando la dirección del contrato JesusCrypt
//     await deployer.deploy(JesusCryptPresale, jesusCryptInstance.address);
//     const jesusCryptPresaleInstance = await JesusCryptPresale.deployed();

//     // Actualizar el contrato JesusCrypt con la dirección del contrato JesusCryptPresale
//     await jesusCryptInstance.setPresaleContract(jesusCryptPresaleInstance.address);
// };
