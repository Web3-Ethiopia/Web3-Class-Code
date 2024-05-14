// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../compoundContracts/CometInterface.sol";

import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {console} from "forge-std/Test.sol";

interface IWETH is IERC20{
    function withdraw(uint) external;
    function deposit() payable external;
}

contract InteractFromPool {
    CometInterface public comet;
    IERC20 public interfaceCOMP;

    constructor(address _assetAddress,address _cometProxy) {
        comet = CometInterface(_cometProxy);
        interfaceCOMP= IERC20(_assetAddress);
    }

    receive() external payable { }

    function supplyCollateral() external payable {
        
        // Supply collateral
        // uint256 eth1000=1000000000000000000000; 
        uint256 amount=msg.value;
        uint256 amountSupply=amount*9/10; // supply amount should have room for some gas
        


    

        interfaceCOMP.approve(address(comet),amountSupply*9/10); //approval given to comet proxy for moving COMP

        console.log(comet.balanceOf(address(this)));
        
        comet.supply(address(interfaceCOMP), amountSupply*9/10);
        console.log(comet.balanceOf(address(this)));
        // console.log(IERC20(interfaceWETH).balanceOf(address(this)));
        // comet.collateralBalanceOf(, address(interfaceWETH));
         //supply cometProxy with the wETH to increase collateral position

        
        // 100000000000
        // 90000000000
    }

    function BalanceCheck() public returns (uint256){
        return address(this).balance;
    }

     function isBorrowAllowed() public returns (bool){
        return comet.isBorrowCollateralized(address(this));
    }


    function WithdrawAsset(uint256 _amount)public {
        console.log(address(this).balance);
        
        comet.withdraw(address(interfaceCOMP),_amount); // currently withdrawing  wETH incase of a different asset will be considered as borrowing
        interfaceCOMP.transfer(address(this),_amount); //withdrawl from wETH to ETH into this contract
        // console.log(address(this).balance);
        msg.sender.call{value:_amount}(""); //Eth back to msg.sender
        // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }

    function BorrowAsset(address _asset,uint256 _amount)public {
        //Borrow USDC from collateral provided in COMP during initialising

        console.log(IERC20(_asset).balanceOf(address(this))); // balance check for USDC = 0

        comet.withdraw(_asset,_amount); // withdrawing USDC based on COMP supplied as collateral
      
        console.log(IERC20(_asset).balanceOf(address(this))); // borrowed USDC updates the balance
        
    }

    
}