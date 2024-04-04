// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// interface IWalletPoolP {
//     struct RateMechanics{
//         uint8 PercentageRate;
//         uint256 amount;
//         bytes2 eventData;
//     }

//     // struct APRMechanics{

//     // }

//     function APRRateMechanics(RateMechanics memory _sampleMechanics)external;
// }

// ControllerForContracts
//Implementation caller
// N number of contracts

contract StateContract {
    uint256 public ourNumber;
}

contract WalletPoolProvider is StateContract {
    function ChangeNumber(address _addressToCall) public returns (bool) {
        (bool success, ) = _addressToCall.delegatecall(
            abi.encodeWithSignature("addToNumber()", "")
        );
        return success;
    }
}

contract WalletPoolProviderB is StateContract {
    constructor() {}

    function ChangeNumber(address _addressToCall) public returns (bool) {
        (bool success, ) = _addressToCall.delegatecall(
            abi.encodeWithSignature("subToNumber()", "")
        );
        return success;
    }
}

contract WalletPoolProviderFactory {
    address public activeContractState;
    address public implementationContract;

    constructor(address _WalletPoolProvider, address _implementationContract) {
        activeContractState = _WalletPoolProvider;
        implementationContract = _implementationContract;
    }

    function setActiveProvider(address _providerContract) public {
        activeContractState = _providerContract;
    }

    function subToNumber() public {
        (bool success, ) = activeContractState.call(
            abi.encodeWithSignature(
                "ChangeNumber(address)",
                implementationContract
            )
        );
        require(success, "Not true");
    }
}

contract ImplementationController is StateContract {
    constructor() {}

    function addToNumber() public {
        ourNumber = ourNumber + 1;
    }

    function subToNumber() public {
        uint256 _ourNumber;
        _ourNumber=ourNumber;
        unchecked { _ourNumber-= 1;}

        ourNumber=_ourNumber;
    }
}
