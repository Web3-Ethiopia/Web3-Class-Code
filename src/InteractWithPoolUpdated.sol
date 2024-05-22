// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DelegateCallHandler.sol";
import "../compoundContracts/CometInterface.sol";
import "../compoundContracts/CometRewards.sol";
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
    DelegateCallHandler public delegateCallHandler;

    constructor(address _assetAddress, address _cometProxy, address _delegateCallHandler) {
        comet = CometInterface(_cometProxy);
        interfaceCOMP = IERC20(_assetAddress);
        rewards = CometRewards(RewardsAddr);
        delegateCallHandler = DelegateCallHandler(_delegateCallHandler);
    }



    struct USER{
        uint256 supply;
        bool isBorrowing;
        uint256 totalBorrowAmount;
        mapping(address asset=>uint256) SuppliedCollaterals;
        address[] lender;
        bool canBorrow;
    }

    // mapping(address=>USER);
    receive() external payable {}

    function supplyCollateral(uint256 amount) external payable {
        // comet.getAssetInfoByAddress(asset);

        // require(condition);
        uint256 amountSupply = amount * 9 / 10;
        USER mainUser=new USER;
        interfaceCOMP.approve(address(comet), amountSupply);
        // (bool success,) = address(delegateCallHandler).delegatecall(
        //     abi.encodeWithSignature("supply(address,uint)", address(interfaceCOMP), amountSupply)
        // );
        // require(success, "Delegatecall failed");
        // comet.getAssetInfoByAddress(asset);
        comet.supply(address(interfaceCOMP), amountSupply *9/10);
    }

    function isBorrowAllowed() public returns (bool) {
        return comet.isBorrowCollateralized(tx.origin);
    }

    function isLiquidatable() public returns (bool) {
        return comet.isLiquidatable(tx.origin);
    }

    function BuyCollateral(address _asset, uint256 usdcAmount) public {
        IERC20(USDCBase).transferFrom(tx.origin, address(this), usdcAmount);
        IERC20(USDCBase).approve(address(comet), usdcAmount);
        comet.buyCollateral(_asset, 0, 1, tx.origin);
    }

    function WithdrawAsset(uint256 _amount) public {
        comet.withdraw(address(interfaceCOMP), _amount);
    }

    function BorrowAsset(address _asset, uint256 _amount) public {
        (bool success,) = address(delegateCallHandler).delegatecall(
            abi.encodeWithSignature("withraw(address,uint)", tx.origin, _amount)
        );

        // CometInterface(_cometProxy);
        require(success, "Delegatecall failed");
    }

    function getSuppleAPR() public returns (uint64) {
        uint256 util = comet.getUtilization();
        return comet.getSupplyRate(util);
    }

    function getBorrowAPR() public returns (uint256) {
        uint256 util = comet.getUtilization();
        uint64 borrowRate = comet.getBorrowRate(util);
        uint256 APR = borrowRate * 864 * 365 / 1e13;

        // Use delegatecall to execute comet.accrueAccount with tx.origin context
        // (bool success, ) = address(delegateCallHandler).delegatecall(abi.encodeWithSignature("accrueAccount(address)", tx.origin));
        // require(success, "Delegatecall failed");

        CometRewards.RewardOwed memory rewardDetails = delegateCallHandler.getRewardOwed(address(comet), tx.origin);
        return APR;
    }
}
