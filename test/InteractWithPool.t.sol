// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {LendingPoolSetup} from '../src/CompoundMain.sol';
import {InteractFromPool} from "../src/InteractWithPool.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

   // uint256 eth1000=1000000000000000000000;
contract CometTest is Test {
   InteractFromPool public MainContract;

    function setUp() public {
        

        // vm.startPrank(CompAccount);
        // MainContract=new LendingPoolSetup(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e,0xc28aD44975C614EaBe0Ed090207314549e1c6624);
        MainContract=new InteractFromPool(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531,0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e);
    }

    function testFuzz_Setup() public {
       
        // MainContract.setFactory()
        address accountMain=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        
        vm.startPrank(accountMain);
        deal(0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531,address(MainContract), 10e20);
        
        // console.log(IERC20(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238).balanceOf(address(MainContract)));
        MainContract.supplyCollateral{value:10e19}();
        MainContract.BorrowAsset(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238, 10e8); //Borrow USDC using Compound supply provided above
    }

    function run() public{

    }
}
