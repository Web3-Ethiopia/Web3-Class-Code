// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../compoundContracts/CometInterface.sol";
import "../../compoundContracts/CometRewards.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import "../../compoundContracts/CometStorage.sol";
import {console} from "forge-std/Test.sol";

interface IWETH is IERC20 {
    function withdraw(uint256) external;
    function deposit() external payable;
}


contract MockCall{
    function findSender()public view returns (address){
        return msg.sender;
    }
}

contract InteractFromPool is CometStorage {
    CometRewards public rewards;
    CometInterface public comet;
    IERC20 public interfaceCOMP;
    MockCall public callContract;
    address public constant USDCBase = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address public constant RewardsAddr = 0x8bF5b658bdF0388E8b482ED51B14aef58f90abfD;
    address public constant TARGET_CONTRACT=0xAec1F48e02Cfb822Be958B68C7957156EB3F0b6e;
    address public baseToken;
    // uint104 internal totalSupplyBase;
    // uint104 internal totalBorrowBase;
    
    struct USER{
        uint256 supply;
        bool isBorrowing;
        uint256 totalBorrowAmount;
        mapping(address asset=>uint256) SuppliedCollaterals;
        bool canBorrow;
    }

    // mapping(address=>USER);

    constructor(address _assetAddress, address _cometProxy) payable {
        comet = CometInterface(_cometProxy);
        interfaceCOMP = IERC20(_assetAddress);
        rewards = CometRewards(RewardsAddr);
        callContract=new MockCall();
        baseToken=USDCBase;
    }

    receive() external payable {}

    fallback() external payable {
        _delegate(msg.data);
    }

    function _delegate(bytes memory _data) internal returns(bool) {
        console.log(msg.sender);
        (bool success, ) = TARGET_CONTRACT.delegatecall(_data);
        
        require(success, "Delegate call failed");
        return success;
    }

    function _delegate2(bytes memory _data) internal returns(bytes memory) {
        console.log(msg.sender);
        (bool success, bytes memory amountData ) = TARGET_CONTRACT.delegatecall(_data);
        
        
        // require(amount>0, "Delegate call failed");
        return amountData;
    }

    function supplyCollateralMain(uint256 amountSupply) external payable {

        (bool success3,)=address(interfaceCOMP).delegatecall(abi.encodeWithSignature("approve(address,uint256)", address(comet),10e20));
      
        bytes memory data = abi.encodeWithSignature("supply(address,uint256)",address(comet),amountSupply);
        bytes memory data2 = abi.encodeWithSignature("isBorrowCollateralized(address)",msg.sender);
        // bytes memory borrowData=abi.encodeWithSignature("",msg.sender);
        bytes memory data3 = abi.encodeWithSignature("withdraw(address,uint)",USDCBase,10e40);
        console.log("Before Supply");
        console.logInt(userBasic[msg.sender].principal);
        (bool success4, ) = TARGET_CONTRACT.delegatecall(abi.encodeWithSignature("accrueInternal()"));
        require(success4, "Accrue failed");
        console.log(IERC20(address(interfaceCOMP)).balanceOf(msg.sender));
        console.log(IERC20(address(interfaceCOMP)).balanceOf(address(this)));
        
        (bool success)=_delegate(data);
        console.logInt(userBasic[msg.sender].principal);
        // console.log(IERC20(address(interfaceCOMP)).balanceOf(msg.sender));
        (bool success2)=_delegate(data2);
        // (bytes memory amount)=_delegate2(data3);
        // console.log("Before Withdrawl");
        // console.log(IERC20(USDCBase).balanceOf(msg.sender));
        // (bool success3) = _delegate(data3);
        // console.log("After Withdrawl");
        // console.log(IERC20(USDCBase).balanceOf(msg.sender));
        // console.log("post delegate call");
        console.log(success);
        console.log(success2);
        console.log(success3);
    } 

    function supplyCollateral() external payable {
        // Supply collateral
        // uint256 eth1000=1000000000000000000000;
        uint256 amount = msg.value;
        uint256 amountSupply = amount * 9 / 10; // supply amount should have room for some gas

        interfaceCOMP.approve(address(comet), amountSupply); //approval given to comet proxy for moving COMP

        console.log("balance before supply");

        // console.log(comet.balanceOf(address(this)));
       

        console.log(IERC20(interfaceCOMP).balanceOf(address(this)));
        comet.supply(address(interfaceCOMP), amountSupply * 9 / 10);
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
