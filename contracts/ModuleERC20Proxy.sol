// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (proxy/transparent/TransparentUpgradeableProxy.sol)

pragma solidity ^0.8.0;

contract ModuleERC20Proxy {
    address public implementation;
    address public proxyAdmin;

    modifier onlyProxyAdmin() {
        require(
            msg.sender == proxyAdmin,
            "ModuleERC20Proxy: caller is not proxy admin"
        );
        _;
    }

    constructor(address _implementation, bytes memory _data) payable {
        proxyAdmin = address(0xc63cf6c8E1f3DF41085E9d8Af49584dae1432b4f);
        implementation = _implementation;
        if (_data.length > 0) {
            _functionDelegateCall(
                _implementation,
                _data,
                "ModuleERC20Proxy: delegate call failed"
            );
        }
    }

    fallback() external payable {
        _delegate(implementation);
    }

    receive() external payable {
        _delegate(implementation);
    }

    function changeProxyAdmin(address newProxyAdmin) external onlyProxyAdmin {
        proxyAdmin = newProxyAdmin;
    }

    function upgradeTo(address newImplementation) external onlyProxyAdmin {
        implementation = newImplementation;
    }

    function upgradeToAndCall(address newImplementation, bytes calldata data)
        external
        payable
        onlyProxyAdmin
    {
        implementation = newImplementation;
        _functionDelegateCall(
            implementation,
            data,
            "ModuleERC20Proxy: delegate call failed"
        );
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
}
