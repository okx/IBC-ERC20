# IBC-ERC20

## 项目概述

IBC-ERC20 的合约主要是服务于 OKC 的 IBC 功能，当有其他链通过 IBC 协议向 OKC 跨链新的资产的时候，OKC 会自动为该资产部署一套对应的 ERC20 合约，包括：

- contracts/ModuleERC20.sol
- contracts/ModuleERC20Proxy.sol

同时，如果有部署在 OKC 上的原生 ERC20 资产，想要通过 IBC 协议跨到其他的链上，那么该 ERC20 需要继承以下合约：

- contracts/nativeERC20/NativeERC20Base.sol

## 合约说明：

1. ERC20.sol: 基本的 ERC20 实现，ModuleERC20 合约的父合约。
2. ModuleERC20.sol: 继承了 ERC20 合约，并实现了使用 IBC 跨链相关的方法和事件。
3. ModuleERC20Proxy: ModuleERC20 的代理合约，实现了基本的代理功能，没有使用 ERC1967。
4. NativeERC20Base.sol: 定义了 OKC 本地的 ERC20 想要使用 IBC 跨链需要实现的基本功能。
5. MockNativeERC20.sol: 构造了一个继承 NativeERC20Base 的示例合约
