// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../compoundContracts/CometInterface.sol";
import "../../compoundContracts/CometRewards.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import {console} from "forge-std/Test.sol";

interface IWETH is IERC20 {
    function withdraw(uint256) external;
    function deposit() external payable;
}

contract InteractFromPool {
    CometRewards public rewards;
    CometInterface public comet;
    IERC20 public interfaceCOMP;
    address public constant USDCBase = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address public constant RewardsAddr = 0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD;


    
    struct USER{
        uint256 supply;
        bool isBorrowing;
        uint256 totalBorrowAmount;
        mapping(address asset=>uint256) SuppliedCollaterals;
        bool canBorrow;
    }

    // mapping(address=>USER);

    constructor(address _assetAddress, address _cometProxy) {
        comet = CometInterface(_cometProxy);
        interfaceCOMP = IERC20(_assetAddress);
        rewards = CometRewards(RewardsAddr);
    }

    receive() external payable {}

    function supplyCollateral() external payable {
        // Supply collateral
        // uint256 eth1000=1000000000000000000000;
        uint256 amount = msg.value;
        uint256 amountSupply = amount * 9 / 10; // supply amount should have room for some gas

        interfaceCOMP.approve(address(comet), amountSupply); //approval given to comet proxy for moving COMP

        console.log("balance before supply");
        // console.log(comet.balanceOf(address(this)));

        console.log(IERC20(interfaceCOMP).balanceOf(address(this)));
        comet.supplyTo(msg.sender, address(interfaceCOMP), amountSupply * 9 / 10);
        console.log("balance post supply");
        console.log(comet.collateralBalanceOf(msg.sender, address(interfaceCOMP)));
        console.log(IERC20(interfaceCOMP).balanceOf(address(this)));
        // comet.collateralBalanceOf(, address(interfaceWETH));
        //supply cometProxy with the wETH to increase collateral position

        // 100000000000
        // 90000000000
    }

    function BalanceCheck() public returns (uint256) {
        return address(this).balance;
    }

    function isBorrowAllowed() public returns (bool) {
        return comet.isBorrowCollateralized(msg.sender);
    }

    function isLiquidatable() public returns (bool) {
        return comet.isLiquidatable(msg.sender);
    }

    function BuyCollateral(address _asset, uint256 usdcAmount) public {
        IERC20(USDCBase).transferFrom(tx.origin, address(this), 10e11);
        console.log(IERC20(USDCBase).balanceOf(address(this)));
        IERC20(USDCBase).approve(address(comet), 10e10);
        comet.buyCollateral(_asset, 0, 1, msg.sender);
    }

    function WithdrawAsset(uint256 _amount) public {
        console.log(address(this).balance);
        // comet.priceScale();
        comet.withdraw(address(interfaceCOMP), _amount); // currently withdrawing  wETH incase of a different asset will be considered as borrowing
            // interfaceCOMP.transfer(address(this),_amount); //withdrawl from wETH to ETH into this contract
            // console.log(address(this).balance);
            // msg.sender.call{value:_amount}(""); //Eth back to msg.sender
            // comet.collateralBalanceOf(address(this), address(interfaceWETH));
    }

    function BorrowAsset(address _asset, uint256 _amount) public {
        //Borrow USDC from collateral provided in COMP during initialising
        // console.log(msg.sender);
        // console.log(IERC20(_asset).balanceOf(address(this))); // balance check for USDC = 0
        console.log(comet.getCollateralReserves(_asset));
        console.log(comet.isBorrowCollateralized(msg.sender));
        comet.withdrawTo(msg.sender, _asset, _amount); // withdrawing USDC based on COMP supplied as collateral
        comet.borrowBalanceOf(msg.sender);

        // IERC20(_asset).transfer(msg.sender, _amount);

        // console.log(IERC20(_asset).balanceOf(address(this))); // borrowed USDC updates the balance
    }

    function getSuppleAPR() public returns (uint64) {
        uint256 util = comet.getUtilization();
        return comet.getSupplyRate(util);
    }

    function getBorrowAPR() public returns (uint256) {
        uint256 util = comet.getUtilization();
        // console.log(util);
        uint64 borrowRate = comet.getBorrowRate(util);
        // console.log(borrowRate);
        uint256 APR = borrowRate * 864 * 365 / 1e13;
        console.log("balance before accrual");
        console.log(IERC20(address(interfaceCOMP)).balanceOf(tx.origin));
        comet.accrueAccount(tx.origin);
        CometRewards.RewardOwed memory rewardDetails = rewards.getRewardOwed(address(comet), tx.origin);
        console.log("Owed amount and token address");
        console.log(rewardDetails.owed);
        console.log(rewardDetails.token);

        // console.log(IERC20(address(interfaceCOMP)).balanceOf(address(this)));
        console.log("APR");
        console.log(APR);
        return APR;
    }
}
