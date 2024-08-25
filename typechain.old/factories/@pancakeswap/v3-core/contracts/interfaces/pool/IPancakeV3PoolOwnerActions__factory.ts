/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  IPancakeV3PoolOwnerActions,
  IPancakeV3PoolOwnerActionsInterface,
} from "../../../../../../@pancakeswap/v3-core/contracts/interfaces/pool/IPancakeV3PoolOwnerActions";

const _abi = [
  {
    inputs: [
      {
        internalType: "address",
        name: "recipient",
        type: "address",
      },
      {
        internalType: "uint128",
        name: "amount0Requested",
        type: "uint128",
      },
      {
        internalType: "uint128",
        name: "amount1Requested",
        type: "uint128",
      },
    ],
    name: "collectProtocol",
    outputs: [
      {
        internalType: "uint128",
        name: "amount0",
        type: "uint128",
      },
      {
        internalType: "uint128",
        name: "amount1",
        type: "uint128",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint32",
        name: "feeProtocol0",
        type: "uint32",
      },
      {
        internalType: "uint32",
        name: "feeProtocol1",
        type: "uint32",
      },
    ],
    name: "setFeeProtocol",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "lmPool",
        type: "address",
      },
    ],
    name: "setLmPool",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class IPancakeV3PoolOwnerActions__factory {
  static readonly abi = _abi;
  static createInterface(): IPancakeV3PoolOwnerActionsInterface {
    return new utils.Interface(_abi) as IPancakeV3PoolOwnerActionsInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): IPancakeV3PoolOwnerActions {
    return new Contract(
      address,
      _abi,
      signerOrProvider
    ) as IPancakeV3PoolOwnerActions;
  }
}