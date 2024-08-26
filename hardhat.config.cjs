require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@typechain/hardhat");
const dotenv = require("dotenv");

dotenv.config();

const { mnemonic } = process.env;

const config = {
    solidity: {
        compilers: [
            {
                version: "0.7.5",
                settings: {
                    optimizer: {
                        enabled: true,
                        runs: 200,
                    },
                },
            },
        ],
    },
    typechain: {
        outDir: "typechain",
        target: "ethers-v5",
    },
    networks: {
        development: {
            url: "http://127.0.0.1:8545",
            chainId: 1337,
            gas: 6000000,
        },
        bscTestnet: {
            url: `https://data-seed-prebsc-1-s1.binance.org:8545`,
            chainId: 97,
            gas: 6000000,
            gasPrice: 10000000000,
            accounts: { mnemonic: mnemonic },
        },
        bscMainnet: {
            url: `https://bsc-dataseed.binance.org/`,
            chainId: 56,
            gas: 6000000,
            gasPrice: 10000000000,
            accounts: { mnemonic: mnemonic },
        },
    },
};

module.exports = config;
