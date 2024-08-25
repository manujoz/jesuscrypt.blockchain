/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
} from "../common";

export interface JesusCryptAdvisorsInterface extends utils.Interface {
  functions: {
    "CHAINLINK_BNB_USDT()": FunctionFragment;
    "advisorAmountToWithdrawAllowed(address,uint256)": FunctionFragment;
    "advisorTokensIsLockeds(address)": FunctionFragment;
    "advisors(address)": FunctionFragment;
    "advisorsList(uint256)": FunctionFragment;
    "allowance(address,address)": FunctionFragment;
    "approve(address,uint256)": FunctionFragment;
    "balanceOf(address)": FunctionFragment;
    "getLatestBNBPrice()": FunctionFragment;
    "isAdvisor(address)": FunctionFragment;
    "jesusCryptToken()": FunctionFragment;
    "liquidityAdded()": FunctionFragment;
    "maxAmountForAdvisors()": FunctionFragment;
    "maxAmountForOneAdvisor()": FunctionFragment;
    "owner()": FunctionFragment;
    "renounceOwnership()": FunctionFragment;
    "setMaxAmounts(uint256,uint256)": FunctionFragment;
    "toDateTime(uint256)": FunctionFragment;
    "totalSupply()": FunctionFragment;
    "transfer(address,uint256)": FunctionFragment;
    "transferFrom(address,address,uint256)": FunctionFragment;
    "transferOwnership(address)": FunctionFragment;
    "transferToAdvisor(address,uint256)": FunctionFragment;
    "updateAdvisor(address,uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "CHAINLINK_BNB_USDT"
      | "advisorAmountToWithdrawAllowed"
      | "advisorTokensIsLockeds"
      | "advisors"
      | "advisorsList"
      | "allowance"
      | "approve"
      | "balanceOf"
      | "getLatestBNBPrice"
      | "isAdvisor"
      | "jesusCryptToken"
      | "liquidityAdded"
      | "maxAmountForAdvisors"
      | "maxAmountForOneAdvisor"
      | "owner"
      | "renounceOwnership"
      | "setMaxAmounts"
      | "toDateTime"
      | "totalSupply"
      | "transfer"
      | "transferFrom"
      | "transferOwnership"
      | "transferToAdvisor"
      | "updateAdvisor"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "CHAINLINK_BNB_USDT",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "advisorAmountToWithdrawAllowed",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "advisorTokensIsLockeds",
    values: [string]
  ): string;
  encodeFunctionData(functionFragment: "advisors", values: [string]): string;
  encodeFunctionData(
    functionFragment: "advisorsList",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "allowance",
    values: [string, string]
  ): string;
  encodeFunctionData(
    functionFragment: "approve",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "balanceOf", values: [string]): string;
  encodeFunctionData(
    functionFragment: "getLatestBNBPrice",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "isAdvisor", values: [string]): string;
  encodeFunctionData(
    functionFragment: "jesusCryptToken",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "liquidityAdded",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "maxAmountForAdvisors",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "maxAmountForOneAdvisor",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "owner", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "renounceOwnership",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setMaxAmounts",
    values: [BigNumberish, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "toDateTime",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "totalSupply",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "transfer",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "transferFrom",
    values: [string, string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "transferOwnership",
    values: [string]
  ): string;
  encodeFunctionData(
    functionFragment: "transferToAdvisor",
    values: [string, BigNumberish]
  ): string;
  encodeFunctionData(
    functionFragment: "updateAdvisor",
    values: [string, BigNumberish]
  ): string;

  decodeFunctionResult(
    functionFragment: "CHAINLINK_BNB_USDT",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "advisorAmountToWithdrawAllowed",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "advisorTokensIsLockeds",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "advisors", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "advisorsList",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "allowance", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "approve", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "balanceOf", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getLatestBNBPrice",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "isAdvisor", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "jesusCryptToken",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "liquidityAdded",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "maxAmountForAdvisors",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "maxAmountForOneAdvisor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "owner", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "renounceOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMaxAmounts",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "toDateTime", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "totalSupply",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "transfer", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "transferFrom",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferOwnership",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferToAdvisor",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "updateAdvisor",
    data: BytesLike
  ): Result;

  events: {
    "Approval(address,address,uint256)": EventFragment;
    "OwnershipTransferred(address,address)": EventFragment;
    "Transfer(address,address,uint256)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "Approval"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "OwnershipTransferred"): EventFragment;
  getEvent(nameOrSignatureOrTopic: "Transfer"): EventFragment;
}

export interface ApprovalEventObject {
  owner: string;
  spender: string;
  value: BigNumber;
}
export type ApprovalEvent = TypedEvent<
  [string, string, BigNumber],
  ApprovalEventObject
>;

export type ApprovalEventFilter = TypedEventFilter<ApprovalEvent>;

export interface OwnershipTransferredEventObject {
  previousOwner: string;
  newOwner: string;
}
export type OwnershipTransferredEvent = TypedEvent<
  [string, string],
  OwnershipTransferredEventObject
>;

export type OwnershipTransferredEventFilter =
  TypedEventFilter<OwnershipTransferredEvent>;

export interface TransferEventObject {
  from: string;
  to: string;
  value: BigNumber;
}
export type TransferEvent = TypedEvent<
  [string, string, BigNumber],
  TransferEventObject
>;

export type TransferEventFilter = TypedEventFilter<TransferEvent>;

export interface JesusCryptAdvisors extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: JesusCryptAdvisorsInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    CHAINLINK_BNB_USDT(overrides?: CallOverrides): Promise<[string]>;

    advisorAmountToWithdrawAllowed(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    advisorTokensIsLockeds(
      _advisor: string,
      overrides?: CallOverrides
    ): Promise<[boolean]>;

    advisors(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber] & {
        amount: BigNumber;
        remainingAmount: BigNumber;
        unlockTime: BigNumber;
      }
    >;

    advisorsList(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[string]>;

    allowance(
      owner: string,
      spender: string,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;

    approve(
      spender: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    balanceOf(account: string, overrides?: CallOverrides): Promise<[BigNumber]>;

    getLatestBNBPrice(overrides?: CallOverrides): Promise<[BigNumber]>;

    isAdvisor(_advisor: string, overrides?: CallOverrides): Promise<[boolean]>;

    jesusCryptToken(overrides?: CallOverrides): Promise<[string]>;

    liquidityAdded(
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    maxAmountForAdvisors(overrides?: CallOverrides): Promise<[BigNumber]>;

    maxAmountForOneAdvisor(overrides?: CallOverrides): Promise<[BigNumber]>;

    owner(overrides?: CallOverrides): Promise<[string]>;

    renounceOwnership(
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    setMaxAmounts(
      _maxAmountForOneAdvisor: BigNumberish,
      _maxAmountForAdvisors: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    toDateTime(
      _timestamp: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber[]]>;

    totalSupply(overrides?: CallOverrides): Promise<[BigNumber]>;

    transfer(
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    transferFrom(
      sender: string,
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    transferToAdvisor(
      _to: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;

    updateAdvisor(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<ContractTransaction>;
  };

  CHAINLINK_BNB_USDT(overrides?: CallOverrides): Promise<string>;

  advisorAmountToWithdrawAllowed(
    _advisor: string,
    _amount: BigNumberish,
    overrides?: CallOverrides
  ): Promise<boolean>;

  advisorTokensIsLockeds(
    _advisor: string,
    overrides?: CallOverrides
  ): Promise<boolean>;

  advisors(
    arg0: string,
    overrides?: CallOverrides
  ): Promise<
    [BigNumber, BigNumber, BigNumber] & {
      amount: BigNumber;
      remainingAmount: BigNumber;
      unlockTime: BigNumber;
    }
  >;

  advisorsList(arg0: BigNumberish, overrides?: CallOverrides): Promise<string>;

  allowance(
    owner: string,
    spender: string,
    overrides?: CallOverrides
  ): Promise<BigNumber>;

  approve(
    spender: string,
    amount: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  balanceOf(account: string, overrides?: CallOverrides): Promise<BigNumber>;

  getLatestBNBPrice(overrides?: CallOverrides): Promise<BigNumber>;

  isAdvisor(_advisor: string, overrides?: CallOverrides): Promise<boolean>;

  jesusCryptToken(overrides?: CallOverrides): Promise<string>;

  liquidityAdded(
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  maxAmountForAdvisors(overrides?: CallOverrides): Promise<BigNumber>;

  maxAmountForOneAdvisor(overrides?: CallOverrides): Promise<BigNumber>;

  owner(overrides?: CallOverrides): Promise<string>;

  renounceOwnership(
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  setMaxAmounts(
    _maxAmountForOneAdvisor: BigNumberish,
    _maxAmountForAdvisors: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  toDateTime(
    _timestamp: BigNumberish,
    overrides?: CallOverrides
  ): Promise<BigNumber[]>;

  totalSupply(overrides?: CallOverrides): Promise<BigNumber>;

  transfer(
    recipient: string,
    amount: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  transferFrom(
    sender: string,
    recipient: string,
    amount: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  transferOwnership(
    newOwner: string,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  transferToAdvisor(
    _to: string,
    _amount: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  updateAdvisor(
    _advisor: string,
    _amount: BigNumberish,
    overrides?: Overrides & { from?: string }
  ): Promise<ContractTransaction>;

  callStatic: {
    CHAINLINK_BNB_USDT(overrides?: CallOverrides): Promise<string>;

    advisorAmountToWithdrawAllowed(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;

    advisorTokensIsLockeds(
      _advisor: string,
      overrides?: CallOverrides
    ): Promise<boolean>;

    advisors(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<
      [BigNumber, BigNumber, BigNumber] & {
        amount: BigNumber;
        remainingAmount: BigNumber;
        unlockTime: BigNumber;
      }
    >;

    advisorsList(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<string>;

    allowance(
      owner: string,
      spender: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    approve(
      spender: string,
      amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;

    balanceOf(account: string, overrides?: CallOverrides): Promise<BigNumber>;

    getLatestBNBPrice(overrides?: CallOverrides): Promise<BigNumber>;

    isAdvisor(_advisor: string, overrides?: CallOverrides): Promise<boolean>;

    jesusCryptToken(overrides?: CallOverrides): Promise<string>;

    liquidityAdded(overrides?: CallOverrides): Promise<void>;

    maxAmountForAdvisors(overrides?: CallOverrides): Promise<BigNumber>;

    maxAmountForOneAdvisor(overrides?: CallOverrides): Promise<BigNumber>;

    owner(overrides?: CallOverrides): Promise<string>;

    renounceOwnership(overrides?: CallOverrides): Promise<void>;

    setMaxAmounts(
      _maxAmountForOneAdvisor: BigNumberish,
      _maxAmountForAdvisors: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;

    toDateTime(
      _timestamp: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber[]>;

    totalSupply(overrides?: CallOverrides): Promise<BigNumber>;

    transfer(
      recipient: string,
      amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;

    transferFrom(
      sender: string,
      recipient: string,
      amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<boolean>;

    transferOwnership(
      newOwner: string,
      overrides?: CallOverrides
    ): Promise<void>;

    transferToAdvisor(
      _to: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;

    updateAdvisor(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "Approval(address,address,uint256)"(
      owner?: string | null,
      spender?: string | null,
      value?: null
    ): ApprovalEventFilter;
    Approval(
      owner?: string | null,
      spender?: string | null,
      value?: null
    ): ApprovalEventFilter;

    "OwnershipTransferred(address,address)"(
      previousOwner?: string | null,
      newOwner?: string | null
    ): OwnershipTransferredEventFilter;
    OwnershipTransferred(
      previousOwner?: string | null,
      newOwner?: string | null
    ): OwnershipTransferredEventFilter;

    "Transfer(address,address,uint256)"(
      from?: string | null,
      to?: string | null,
      value?: null
    ): TransferEventFilter;
    Transfer(
      from?: string | null,
      to?: string | null,
      value?: null
    ): TransferEventFilter;
  };

  estimateGas: {
    CHAINLINK_BNB_USDT(overrides?: CallOverrides): Promise<BigNumber>;

    advisorAmountToWithdrawAllowed(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    advisorTokensIsLockeds(
      _advisor: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    advisors(arg0: string, overrides?: CallOverrides): Promise<BigNumber>;

    advisorsList(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    allowance(
      owner: string,
      spender: string,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    approve(
      spender: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    balanceOf(account: string, overrides?: CallOverrides): Promise<BigNumber>;

    getLatestBNBPrice(overrides?: CallOverrides): Promise<BigNumber>;

    isAdvisor(_advisor: string, overrides?: CallOverrides): Promise<BigNumber>;

    jesusCryptToken(overrides?: CallOverrides): Promise<BigNumber>;

    liquidityAdded(
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    maxAmountForAdvisors(overrides?: CallOverrides): Promise<BigNumber>;

    maxAmountForOneAdvisor(overrides?: CallOverrides): Promise<BigNumber>;

    owner(overrides?: CallOverrides): Promise<BigNumber>;

    renounceOwnership(
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    setMaxAmounts(
      _maxAmountForOneAdvisor: BigNumberish,
      _maxAmountForAdvisors: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    toDateTime(
      _timestamp: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    totalSupply(overrides?: CallOverrides): Promise<BigNumber>;

    transfer(
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    transferFrom(
      sender: string,
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    transferToAdvisor(
      _to: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;

    updateAdvisor(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    CHAINLINK_BNB_USDT(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    advisorAmountToWithdrawAllowed(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    advisorTokensIsLockeds(
      _advisor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    advisors(
      arg0: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    advisorsList(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    allowance(
      owner: string,
      spender: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    approve(
      spender: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    balanceOf(
      account: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    getLatestBNBPrice(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    isAdvisor(
      _advisor: string,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    jesusCryptToken(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    liquidityAdded(
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    maxAmountForAdvisors(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    maxAmountForOneAdvisor(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    owner(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    renounceOwnership(
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    setMaxAmounts(
      _maxAmountForOneAdvisor: BigNumberish,
      _maxAmountForAdvisors: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    toDateTime(
      _timestamp: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    totalSupply(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    transfer(
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    transferFrom(
      sender: string,
      recipient: string,
      amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    transferOwnership(
      newOwner: string,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    transferToAdvisor(
      _to: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;

    updateAdvisor(
      _advisor: string,
      _amount: BigNumberish,
      overrides?: Overrides & { from?: string }
    ): Promise<PopulatedTransaction>;
  };
}
