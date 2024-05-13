// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import "../src/CompoundMain.sol";
import {InteractFromPool} from "../src/InteractWithPool.sol";

contract CometScript is Script {
    InteractFromPool public MainContract;
    
    function setUp() public {
        
        MainContract=new InteractFromPool(0xE3E0106227181958aBfbA960C13d0Fe52c733265);
    }

    function run() public {
        uint256 CompAccount=vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(CompAccount);
        // MainContract.setFactory()
        MainContract.supplyCollateral(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531, 100000000000000 );
    }
}

//forge script script/Compound.s.sol