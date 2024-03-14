// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Receiver {
    uint public addFromCaller;
    event Received(address caller, uint amount, string message);
    event DelegatecallMade(string callMade,uint stateVariable);
    

    receive() external payable { 
        emit Received(msg.sender, msg.value, "Fallback called");
    }

    // fallback() external payable {
    //     emit Received(msg.sender, msg.value, "Fallback called");
    // }

    function foo(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);
        return _x + 1;
    }

    function addOne() public payable {
        addFromCaller+=1;
        emit DelegatecallMade("It is calling", addFromCaller);
    }
}

contract Caller {
    uint public addFromCaller;
    event Response(bool success, bytes data);
    

    // Sending Ether and calling function foo
    function callFoo(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("addOne()")
        );

        emit Response(success, data);
    }

    // Sending Ether to the fallback function
    function sendEther(address payable _addr) public payable {
        (bool success,) = _addr.call{value: msg.value}("");
        require(success, "Failed to send Ether");
    }
}
