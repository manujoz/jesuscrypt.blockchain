const HDWalletProvider = require("@truffle/hdwallet-provider");
const dotenv = require("dotenv");

dotenv.config();

// const mnemonic = "city label patch dragon nurse aim ill isolate ability robust grain until";
const mnemonic = process.env.MNEMONIC;

module.exports = {
    networks: {
        development: {
            host: "127.0.0.1",
            port: 8545,
            network_id: "*", // Cualquier red
        },
        bscTestnet: {
            provider: () => new HDWalletProvider(mnemonic, `https://data-seed-prebsc-1-s1.binance.org:8545`),
            network_id: 97, // BSC Testnet ID
            gas: 6000000, // Límite de gas
            gasPrice: 10000000000, // Precio del gas en wei (10 Gwei)
            confirmations: 10,
            timeoutBlocks: 200,
            skipDryRun: true,
        },
        bscMainnet: {
            provider: () => new HDWalletProvider(mnemonic, `https://bsc-dataseed.binance.org/`),
            network_id: 56, // BSC Mainnet ID
            confirmations: 10,
            timeoutBlocks: 200,
            skipDryRun: true,
        },
    },
    compilers: {
        solc: {
            version: "0.8.21", // Versión del compilador Solidity
        },
    },
};
