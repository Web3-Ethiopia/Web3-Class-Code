// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {InteractFromPool} from "../src/InteractWithPoolUpdated.sol";
import {DelegateCallHandler} from "../src/DelegateCallHandler.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract CometTest is Test {
    InteractFromPool public MainContract;
    DelegateCallHandler public delegateCallHandler;
    address public constant USDCAddr = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address public constant COMP = 0xA6c8D1c55951e8AC44a0EaA959Be5Fd21cc07531;
    address constant private accountMain = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant private collateralBuyer = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    function setUp() public {
        vm.startPrank(accountMain, accountMain);
        delegateCallHandler = new DelegateCallHandler(0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e, 0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD);
        MainContract = new InteractFromPool(COMP, 0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e, address(delegateCallHandler));
    }

    function testFuzz_Setup() public {
        deal(COMP, address(MainContract), 10e21);
        MainContract.supplyCollateral{value: 10e21}();
        console.log(IERC20(USDCAddr).balanceOf(accountMain));
        skip(100000000);
        MainContract.BorrowAsset(USDCAddr, 1100000);
        MainContract.getBorrowAPR();
        console.log(IERC20(USDCAddr).balanceOf(accountMain));
        MainContract.isLiquidatable();
    }

    function run() public {}
}
