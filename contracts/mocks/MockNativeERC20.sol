// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../ERC20.sol";
import "../nativeERC20/INativeERC20.sol";

contract MockNativeERC20 is INativeERC20, ERC20 {
    function initialize(string memory denom_, uint8 decimals_) external {
        __ERC20_init(denom_, denom_, decimals_);
    }

    function mint_by_okc_module(address addr, uint256 amount) public override {
        require(msg.sender == moduleAddress);
        _transfer(msg.sender, addr, amount);
    }

    function send_to_wasm(string memory recipient, uint256 amount)
        public
        override
    {
        _transfer(msg.sender, moduleAddress, amount);
        emit __OKCSendToWasm(msg.sender, recipient, amount);
    }

    function send_native20_to_ibc(
        string memory recipient,
        uint256 amount,
        string memory portID,
        string memory channelID
    ) public override {
        _transfer(msg.sender, moduleAddress, amount);
        emit __OKCSendNative20ToIbc(
            msg.sender,
            recipient,
            amount,
            portID,
            channelID
        );
    }

    // for testing
    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    // for testing
    function burn(address account, uint256 amount) external {
        _burn(account, amount);
    }
}
