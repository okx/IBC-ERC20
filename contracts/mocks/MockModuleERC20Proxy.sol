// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

contract MockModuleERC20Proxy {
    struct AddressSlot {
        address value;
    }

    bytes32 internal constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    bytes32 internal constant _ADMIN_SLOT =
        0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    event Upgraded(address indexed implementation);
    event AdminChanged(address previousAdmin, address newAdmin);

    constructor(address _implementation, bytes memory _data) payable {
        _setAdmin(msg.sender);
        _setImplementation(_implementation);
        if (_data.length > 0) {
            _functionDelegateCall(
                _implementation,
                _data,
                "ModuleERC20Proxy: delegate call failed"
            );
        }
    }

    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        } else {
            _delegate(_getImplementation());
        }
    }

    fallback() external payable {
        _delegate(_getImplementation());
    }

    receive() external payable {
        _delegate(_getImplementation());
    }

    function admin() external ifAdmin returns (address admin_) {
        admin_ = _getAdmin();
    }

    function implementation()
        external
        ifAdmin
        returns (address implementation_)
    {
        implementation_ = _getImplementation();
    }

    function changeAdmin(address newAdmin) external ifAdmin {
        _setAdmin(newAdmin);
        emit AdminChanged(_getAdmin(), newAdmin);
    }

    function upgradeTo(address newImplementation) external ifAdmin {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    function upgradeToAndCall(address newImplementation, bytes calldata data)
        external
        payable
        ifAdmin
    {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);

        _functionDelegateCall(
            newImplementation,
            data,
            "ModuleERC20Proxy: delegate call failed"
        );
    }

    function _setImplementation(address newImplementation) private {
        require(
            _isContract(newImplementation),
            "ModuleERC20Proxy: new implementation is not a contract"
        );
        _getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    function _getImplementation() internal view returns (address) {
        return _getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    function _setAdmin(address newAdmin) private {
        require(
            newAdmin != address(0),
            "ModuleERC20Proxy: new admin is the zero address"
        );
        _getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    function _getAdmin() internal view returns (address) {
        return _getAddressSlot(_ADMIN_SLOT).value;
    }

    function _delegate(address _implementation) internal {
        assembly {
            calldatacopy(0, 0, calldatasize())

            let result := delegatecall(
                gas(),
                _implementation,
                0,
                calldatasize(),
                0,
                0
            )

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    function _functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            _isContract(target),
            "ModuleERC20Proxy: delegate call to non-contract"
        );

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function _getAddressSlot(bytes32 slot)
        internal
        pure
        returns (AddressSlot storage r)
    {
        assembly {
            r.slot := slot
        }
    }
}
