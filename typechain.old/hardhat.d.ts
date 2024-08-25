/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { ethers } from "ethers";
import {
  FactoryOptions,
  HardhatEthersHelpers as HardhatEthersHelpersBase,
} from "@nomiclabs/hardhat-ethers/types";

import * as Contracts from ".";

declare module "hardhat/types/runtime" {
  interface HardhatEthersHelpers extends HardhatEthersHelpersBase {
    getContractFactory(
      name: "Ownable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Ownable__factory>;
    getContractFactory(
      name: "IERC165",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC165__factory>;
    getContractFactory(
      name: "ERC20",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC20__factory>;
    getContractFactory(
      name: "IERC20",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC20__factory>;
    getContractFactory(
      name: "IERC721",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721__factory>;
    getContractFactory(
      name: "IERC721Enumerable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Enumerable__factory>;
    getContractFactory(
      name: "IERC721Metadata",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Metadata__factory>;
    getContractFactory(
      name: "Pausable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Pausable__factory>;
    getContractFactory(
      name: "IPancakeV3Pool",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3Pool__factory>;
    getContractFactory(
      name: "IPancakeV3PoolActions",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolActions__factory>;
    getContractFactory(
      name: "IPancakeV3PoolDerivedState",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolDerivedState__factory>;
    getContractFactory(
      name: "IPancakeV3PoolEvents",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolEvents__factory>;
    getContractFactory(
      name: "IPancakeV3PoolImmutables",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolImmutables__factory>;
    getContractFactory(
      name: "IPancakeV3PoolOwnerActions",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolOwnerActions__factory>;
    getContractFactory(
      name: "IPancakeV3PoolState",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPancakeV3PoolState__factory>;
    getContractFactory(
      name: "IERC721Permit",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Permit__factory>;
    getContractFactory(
      name: "INonfungiblePositionManager",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.INonfungiblePositionManager__factory>;
    getContractFactory(
      name: "IPeripheryImmutableState",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPeripheryImmutableState__factory>;
    getContractFactory(
      name: "IPeripheryPayments",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPeripheryPayments__factory>;
    getContractFactory(
      name: "IPoolInitializer",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPoolInitializer__factory>;
    getContractFactory(
      name: "AggregatorV3Interface",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.AggregatorV3Interface__factory>;
    getContractFactory(
      name: "IWBNB",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IWBNB__factory>;
    getContractFactory(
      name: "JesusCrypt",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.JesusCrypt__factory>;
    getContractFactory(
      name: "JesusCryptAdvisors",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.JesusCryptAdvisors__factory>;
    getContractFactory(
      name: "JesusCryptLiquidityLocker",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.JesusCryptLiquidityLocker__factory>;
    getContractFactory(
      name: "JesusCryptPresale",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.JesusCryptPresale__factory>;
    getContractFactory(
      name: "JesusCryptUtils",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.JesusCryptUtils__factory>;

    getContractAt(
      name: "Ownable",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.Ownable>;
    getContractAt(
      name: "IERC165",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC165>;
    getContractAt(
      name: "ERC20",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.ERC20>;
    getContractAt(
      name: "IERC20",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC20>;
    getContractAt(
      name: "IERC721",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721>;
    getContractAt(
      name: "IERC721Enumerable",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Enumerable>;
    getContractAt(
      name: "IERC721Metadata",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Metadata>;
    getContractAt(
      name: "Pausable",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.Pausable>;
    getContractAt(
      name: "IPancakeV3Pool",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3Pool>;
    getContractAt(
      name: "IPancakeV3PoolActions",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolActions>;
    getContractAt(
      name: "IPancakeV3PoolDerivedState",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolDerivedState>;
    getContractAt(
      name: "IPancakeV3PoolEvents",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolEvents>;
    getContractAt(
      name: "IPancakeV3PoolImmutables",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolImmutables>;
    getContractAt(
      name: "IPancakeV3PoolOwnerActions",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolOwnerActions>;
    getContractAt(
      name: "IPancakeV3PoolState",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPancakeV3PoolState>;
    getContractAt(
      name: "IERC721Permit",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Permit>;
    getContractAt(
      name: "INonfungiblePositionManager",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.INonfungiblePositionManager>;
    getContractAt(
      name: "IPeripheryImmutableState",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPeripheryImmutableState>;
    getContractAt(
      name: "IPeripheryPayments",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPeripheryPayments>;
    getContractAt(
      name: "IPoolInitializer",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IPoolInitializer>;
    getContractAt(
      name: "AggregatorV3Interface",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.AggregatorV3Interface>;
    getContractAt(
      name: "IWBNB",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.IWBNB>;
    getContractAt(
      name: "JesusCrypt",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.JesusCrypt>;
    getContractAt(
      name: "JesusCryptAdvisors",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.JesusCryptAdvisors>;
    getContractAt(
      name: "JesusCryptLiquidityLocker",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.JesusCryptLiquidityLocker>;
    getContractAt(
      name: "JesusCryptPresale",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.JesusCryptPresale>;
    getContractAt(
      name: "JesusCryptUtils",
      address: string,
      signer?: ethers.Signer
    ): Promise<Contracts.JesusCryptUtils>;

    // default types
    getContractFactory(
      name: string,
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<ethers.ContractFactory>;
    getContractFactory(
      abi: any[],
      bytecode: ethers.utils.BytesLike,
      signer?: ethers.Signer
    ): Promise<ethers.ContractFactory>;
    getContractAt(
      nameOrAbi: string | any[],
      address: string,
      signer?: ethers.Signer
    ): Promise<ethers.Contract>;
  }
}
