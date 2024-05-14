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
    IERC20 public interfaceWETH;

    constructor(address _assetAddress,address _cometProxy) {
        comet = CometInterface(_cometProxy);
        interfaceWETH= IERC20(_assetAddress);
    }

    receive() external payable { }

    function supplyCollateral() external payable {
        
        // Supply collateral
        // uint256 eth1000=1000000000000000000000; 
        uint256 amount=msg.value;
        uint256 amountSupply=amount*9/10; // supply amount should have room for some gas
        


        // payable(address(this)).call{value:amount}(""); //funding the contract with the required eth to convert into WETH for supply
        // interfaceWETH.transfer(address(this),amountSupply*9/10);
        console.log(interfaceWETH.balanceOf(address(this)));
        // console.log(interfaceWETH.balanceOf(address(this)));
        // interfaceWETH.deposit{value:amountSupply}(); //using WETH contract to deposit eth and get wETH for supplying to the comet proxy

        interfaceWETH.approve(address(comet),amountSupply*9/10); //approval given to comet proxy for moving wEth

        comet.supply(address(interfaceWETH), amountSupply*9/10); //supply cometProxy with the wETH to increase collateral position
        // 100000000000
        // 90000000000
    }

    function BalanceCheck() public returns (uint256){
        return address(this).balance;
    }

    function WithdrawAsset(uint256 _amount)public {
        console.log(address(this).balance);
        comet.withdraw(address(interfaceWETH),_amount); // currently withdrawing  wETH incase of a different asset will be considered as borrowing
        interfaceWETH.transfer(address(this),_amount); //withdrawl from wETH to ETH into this contract
        // console.log(address(this).balance);
        msg.sender.call{value:_amount}(""); //Eth back to msg.sender
        // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }

    function BorrowAsset(address _asset,uint256 _amount)public {
        console.log(address(this).balance);
        
        comet.buyCollateral(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238, 0, _amount, address(this));
        comet.withdraw(_asset,_amount); // currently withdrawing  wETH incase of a different asset will be considered as borrowing
        // interfaceWETH.withdraw(_amount); //withdrawl from wETH to ETH into this contract
        // console.log(address(this).balance);
        console.log(IERC20(_asset).balanceOf(address(this)));
        // msg.sender.call{value:_amount}(""); //Eth back to msg.sender
        // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }

    
}