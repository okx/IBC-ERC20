// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "./ERC20.sol";

contract ModuleERC20 is ERC20 {
    address public constant moduleAddress =
        address(0xc63cf6c8E1f3DF41085E9d8Af49584dae1432b4f);

    event __OKBCSendToIbc(address sender, string recipient, uint256 amount);
    event __OKBCSendToWasm(address sender, string recipient, uint256 amount);

    function initialize(string memory denom_, uint8 decimals_) public {
        __ERC20_init(denom_, denom_, decimals_);
    }

    function native_denom() public view returns (string memory) {
        return symbol();
    }

    function mint_by_okbc_module(address addr, uint256 amount) public {
        require(msg.sender == moduleAddress);
        _mint(addr, amount);
    }

    function burn_by_okbc_module(address addr, uint256 amount) public {
        require(msg.sender == moduleAddress);
        _burn(addr, amount);
    }

    // send an "amount" of the contract token to recipient through IBC
    function send_to_ibc(string memory recipient, uint256 amount) public {
        _burn(msg.sender, amount);
        emit __OKBCSendToIbc(msg.sender, recipient, amount);
    }

    // send an "amount" of the contract token to recipient on wasm
    function send_to_wasm(string memory recipient, uint256 amount) public {
        _burn(msg.sender, amount);
        emit __OKBCSendToWasm(msg.sender, recipient, amount);
    }
}
