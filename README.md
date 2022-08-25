# IBC-ERC20

## Project Overview

The IBC-ERC20 contract mainly serves the IBC function of OKC. When there is a new cross-chain asset from another chain to OKC through the IBC protocol, OKC will automatically deploy a corresponding ERC20 contract for the asset, including:

- contracts/ModuleERC20.sol
- contracts/ModuleERC20Proxy.sol

At the same time, if there are native ERC20 assets deployed on OKC and want to cross to other chains through the IBC protocol, the ERC20 needs to inherit the following contracts:

- contracts/nativeERC20/INativeERC20.sol

## Contract description:

1. ERC20.sol: Basic ERC20 implementation, the parent contract of the ModuleERC20 contract.
2. ModuleERC20.sol: Inherited the ERC20 contract, and implemented the methods and events for IBC protocol.
3. ModuleERC20Proxy: The proxy contract of ModuleERC20 implements basic proxy functions.
4. INativeERC20.sol: It defines the basic functions that OKC's native ERC20 needs to implement for IBC protocol.
