// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LendingPoolSetup} from '../src/CompoundMain.sol';
import {InteractFromPool} from "../src/InteractWithPool.sol";

   // uint256 eth1000=1000000000000000000000;
contract CometTest is Test {
   InteractFromPool public MainContract;

    function setUp() public {
        

        // vm.startPrank(CompAccount);
        // MainContract=new LendingPoolSetup(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e,0xc28aD44975C614EaBe0Ed090207314549e1c6624);
        MainContract=new InteractFromPool(0x2D5ee574e710219a521449679A4A7f2B43f046ad,0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e);
    }

    function testSetup() public {
       
        // MainContract.setFactory()
        address accountMain=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        
        vm.startPrank(accountMain);
        vm.deal(accountMain, 100000000000000000000000);
        console.log(accountMain.balance);
        MainContract.supplyCollateral{value:1000000000000000000000}();
        MainContract.WithdrawAsset(700000000000000000000);
        console.log(accountMain.balance);
        // console.log(address(MainContract).balance);
        // MainContract.BalanceCheck();
    }

    function run() public{

    }
}
