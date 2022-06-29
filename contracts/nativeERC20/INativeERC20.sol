// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract INativeERC20 {
    address public constant moduleAddress =
        address(0xc63cf6c8E1f3DF41085E9d8Af49584dae1432b4f);

    event __OKCSendToWasm(address sender, string recipient, uint256 amount);
    event __OKCSendNative20ToIbc(
        address sender,
        string recipient,
        uint256 amount,
        string portID,
        string channelID
    );

    function mint_by_okc_module(address addr, uint256 amount) external virtual {
        require(msg.sender == moduleAddress);
        // _transfer(msg.sender, addr, amount);
    }

    function send_to_wasm(string memory recipient, uint256 amount)
        external
        virtual
    {
        // _transfer(msg.sender, moduleAddress, amount);
        emit __OKCSendToWasm(msg.sender, recipient, amount);
    }

    function send_native20_to_ibc(
        string memory recipient,
        uint256 amount,
        string memory portID,
        string memory channelID
    ) external virtual {
        // _transfer(msg.sender, moduleAddress, amount);
        emit __OKCSendNative20ToIbc(
            msg.sender,
            recipient,
            amount,
            portID,
            channelID
        );
    }
}
