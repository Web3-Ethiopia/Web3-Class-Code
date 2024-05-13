// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../src/CompoundMain.sol";
import {InteractFromPool} from "../src/InteractWithPool.sol";

contract CometScript is Script {
    InteractFromPool public MainContract;
    
    function setUp() public {
        
        MainContract=new InteractFromPool(0x2D5ee574e710219a521449679A4A7f2B43f046ad,0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e);
    }

    function run() public {
        uint256 CompAccount=vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(CompAccount);
        // MainContract.setFactory()
        MainContract.supplyCollateral{value:1000000000000000000000}();
    }
}

//forge script script/Compound.s.sol