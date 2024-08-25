import type { TypechainUserConfig } from "@typechain/hardhat/dist/types";

import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import { HardhatUserConfig } from "hardhat/config";

import dotenv from "dotenv";
dotenv.config();

const { mnemonic } = process.env;

const config: HardhatUserConfig & { typechain: TypechainUserConfig } = {
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

export default config;
