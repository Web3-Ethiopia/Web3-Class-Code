// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/LowLevel Calls/stateVariablesDelegate.sol";

contract Logic is AllCommonVariables {
    // Storage layout must be the same as the calling contract
    event DoSomethingEvent(uint resultCurrent,string status);

    function doSomething(uint _num) public {
        result = _num + 1;
        emit DoSomethingEvent(result, "yeah its working");

    }

    function writeSomething(string calldata _theVariableString) public {
        theString=_theVariableString;
    }
}
