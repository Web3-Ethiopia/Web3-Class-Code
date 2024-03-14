// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/LowLevel Calls/stateVariablesDelegate.sol";


contract Caller  is AllCommonVariables{
    
    address public libraryAddress;
    

    function setLibraryAddress(address _libraryAddress) public {
        libraryAddress = _libraryAddress;
    }

    function execute(uint _num) public {
        (bool success,) = libraryAddress.delegatecall(
            abi.encodeWithSignature("doSomething(uint256)", _num)
        );
        require(success, "delegatecall failed");
    }

    function writeSomethingForThisContract(string calldata _string) public {
        (bool success,) = libraryAddress.delegatecall(
            abi.encodeWithSignature("writeSomething(string)", _string)
        );
        require(success, "delegatecall failed");
    }
}
