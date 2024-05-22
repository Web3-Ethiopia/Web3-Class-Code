// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
// import "../src/CompoundMain.sol";
import {InteractFromPool} from "../src/InteractWithPoolUpdated.sol";
import "../src/DelegateCallHandler.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

interface IFaucet{
    function drip(address token) external;
}

contract CometScript is Script {
    InteractFromPool public MainContract;
    address public constant USDCAddr = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address public constant COMP = 0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531;
    DelegateCallHandler public delegateCallHandler;
    IFaucet public interfaceFaucet;

    function setUp() public {
        delegateCallHandler = new DelegateCallHandler(
            0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e, 0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD
        );
        MainContract =
            new InteractFromPool(COMP, 0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e, address(delegateCallHandler));

        interfaceFaucet=IFaucet(0x68793eA49297eB75DFB4610B68e076D2A5c7646C);
    }

    function run() public {
        uint256 CompAccount = vm.envUint("ANVIL_ACCOUNT1");
        vm.startBroadcast(CompAccount);

        interfaceFaucet.drip(COMP);
        uint256 balanceMain=IERC20(COMP).balanceOf(msg.sender);
        // deal(COMP,CompAccount,10e21);

        // MainContract.setFactory()
        // MainContract.supplyCollateral(balanceMain-1000);
    }
}

//forge script script/Compound.s.sol
