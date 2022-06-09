// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NativeERC20Base {
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

    function native_denom() public view returns (string memory) {
        return symbol();
    }

    function mint_by_okc_module(address addr, uint256 amount) public {
        require(msg.sender == moduleAddress);
        _mint(addr, amount);
    }

    function burn_by_okc_module(address addr, uint256 amount) public {
        require(msg.sender == moduleAddress);
        _burn(addr, amount);
    }

    function send_to_wasm(string memory recipient, uint256 amount) public {
        _burn(msg.sender, amount);
        emit __OKCSendToWasm(msg.sender, recipient, amount);
    }

    function send_native20_to_ibc(
        string memory recipient,
        uint256 amount,
        string memory portID,
        string memory channelID
    ) public {
        _burn(msg.sender, amount);
        emit __OKCSendNative20ToIbc(
            msg.sender,
            recipient,
            amount,
            portID,
            channelID
        );
    }

    function symbol() public view virtual returns (string memory) {}

    function _mint(address account, uint256 amount) internal virtual {}

    function _burn(address account, uint256 amount) internal virtual {}
}
