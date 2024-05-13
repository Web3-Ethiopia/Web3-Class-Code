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
    IWETH public interfaceWETH;

    constructor(address _wETH,address _cometProxy) {
        comet = CometInterface(_cometProxy);
        interfaceWETH= IWETH(_wETH);
    }

    receive() external payable { }

    function supplyCollateral() external payable {
        
        // Supply collateral
        // uint256 eth1000=1000000000000000000000; 
        uint256 amount=msg.value;
        uint256 amountSupply=amount*9/10;
        console.log(amountSupply);
        payable(address(this)).call{value:amount}("");
        
        interfaceWETH.deposit{value:amountSupply}();
        interfaceWETH.approve(address(comet),amountSupply*9/10); //
        comet.supply(address(interfaceWETH), amountSupply*9/10);
        
    }

    function BalanceCheck() public returns (uint256){
        return address(this).balance;
    }

    function WithdrawAsset(uint256 _amount)public {
        console.log(address(this).balance);
        comet.withdraw(address(interfaceWETH),_amount);
        interfaceWETH.withdraw(_amount);
        console.log(address(this).balance);
        msg.sender.call{value:_amount}("");
        // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }
}