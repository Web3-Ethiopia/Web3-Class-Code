// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
// import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import {ContextUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";

contract DataContract  {
    uint public data;

    function getData() external view returns(uint256) {
        return data;
    }

    function getData(uint256 number) public pure returns(uint) {
        return number;
    }
}

contract StaticCaller is ReentrancyGuard{
    uint public data;
    event Data(uint data);



    function readData(address _addr) public nonReentrant {
        (bool success, bytes memory dataReal) = _addr.staticcall(
            abi.encodeWithSignature("getData()")
        );
        require(success, "staticcall failed");
        emit Data(abi.decode(dataReal, (uint)));
    }
}
