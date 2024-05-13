// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LendingPoolSetup} from '../src/CompoundMain.sol';
import {InteractFromPool} from "../src/InteractWithPool.sol";

contract CometTest is Test {
   InteractFromPool public MainContract;

    function setUp() public {
        

        // vm.startPrank(CompAccount);
        // MainContract=new LendingPoolSetup(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e,0xc28aD44975C614EaBe0Ed090207314549e1c6624);
        MainContract=new InteractFromPool(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e);
    }

    function testSetup() public {
       
        // MainContract.setFactory()
        
        MainContract.supplyCollateral(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531, 10**18);
    }
}
