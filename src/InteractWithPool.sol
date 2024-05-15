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
    address public constant USDCBase=0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;

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

    function isLiquidatable() public returns (bool){
        return comet.isLiquidatable(address(this));
    }

    function BuyCollateral(address _asset, uint256 usdcAmount) public {

        IERC20(USDCBase).transferFrom(tx.origin, address(this), 10e11);
        console.log(IERC20(USDCBase).balanceOf(address(this)));
        IERC20(USDCBase).approve(address(comet), 10e10);
        comet.buyCollateral(_asset, 0, 1, msg.sender);
    }


    function WithdrawAsset(uint256 _amount)public {
        console.log(address(this).balance);
        // comet.priceScale();
        comet.withdraw(address(interfaceCOMP),_amount); // currently withdrawing  wETH incase of a different asset will be considered as borrowing
        // interfaceCOMP.transfer(address(this),_amount); //withdrawl from wETH to ETH into this contract
        // console.log(address(this).balance);
        // msg.sender.call{value:_amount}(""); //Eth back to msg.sender
        // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }

    function BorrowAsset(address _asset,uint256 _amount)public {
        //Borrow USDC from collateral provided in COMP during initialising

        // console.log(IERC20(_asset).balanceOf(address(this))); // balance check for USDC = 0
        // console.log(comet.getCollateralReserves(_asset));
        comet.withdraw(_asset,_amount); // withdrawing USDC based on COMP supplied as collateral
        comet.borrowBalanceOf(address(this));

        IERC20(_asset).transfer(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, _amount);



        // console.log(IERC20(_asset).balanceOf(address(this))); // borrowed USDC updates the balance
        
    }

    function getSuppleAPR() public returns(uint64){
             uint util=comet.getUtilization();
             return comet.getSupplyRate(util);
    }

    function getBorrowAPR()public returns(uint256){
            uint util=comet.getUtilization();
            console.log(util/10e17);
            uint64 borrowRate= comet.getBorrowRate(util);
            console.log(borrowRate);
            uint256 APR=borrowRate*864*365/1e13;
            comet.accrueAccount(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
            console.log(IERC20(address(interfaceCOMP)).balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
            console.log(APR);
            return APR;
    }

    
}