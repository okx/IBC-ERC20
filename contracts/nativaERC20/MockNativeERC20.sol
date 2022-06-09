// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../ERC20.sol";
import "./NativeERC20Base.sol";

contract MockNativeERC20 is ERC20, NativeERC20Base {
    function initialize(string memory denom_, uint8 decimals_) external {
        __ERC20_init(denom_, denom_, decimals_);
    }

    function symbol()
        public
        view
        override(NativeERC20Base, ERC20)
        returns (string memory)
    {
        return super.symbol();
    }

    function _mint(address account, uint256 amount)
        internal
        override(NativeERC20Base, ERC20)
    {
        super._mint(account, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(NativeERC20Base, ERC20)
    {
        super._burn(account, amount);
    }
}
