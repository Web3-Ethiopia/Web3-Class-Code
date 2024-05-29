// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
// import "../src/CompoundMain.sol";
import {InteractFromPool} from "../src/UnusedContracts/InteractWithPool.sol";
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
    // DelegateCallHandler public delegateCallHandler;
    IFaucet public interfaceFaucet;

    function setUp() public {
        // delegateCallHandler = new DelegateCallHandler(
        //     0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e, 0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD
        // );
        

        interfaceFaucet=IFaucet(0x68793eA49297eB75DFB4610B68e076D2A5c7646C);
    }

    function run() public {
        uint256 CompAccount = vm.envUint("ANVIL_ACCOUNT1");
        // console.log(CompAccount);
        vm.startBroadcast(CompAccount);
        
        // MainContract =
            // new InteractFromPool{value:10e20}(COMP, 0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e);
            interfaceFaucet.drip(COMP);
            // console.log(msg.sender);
            uint256 balanceMain=IERC20(COMP).balanceOf(0xd33B56ceaa115020b20dbE29db6b17eDd3795585);
            console.log(balanceMain);
        // deal(COMP,CompAccount,10e21);
            IERC20(COMP).transfer(0xd33B56ceaa115020b20dbE29db6b17eDd3795585, balanceMain-100e18);
            // console.log(IERC20(COMP).balanceOf(address(MainContract)));

        // MainContract.setFactory()
        // MainContract.supplyCollateral(balanceMain-1000);
    }
}

//forge script script/Compound.s.sol
