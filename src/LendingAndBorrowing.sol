// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../compoundContracts/CometInterface.sol";
import "../compoundContracts/CometRewards.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
// import "./DelegateCallHandler.sol";
import {console} from "forge-std/Test.sol";

contract LendingAndBorrowing {
    struct USER { 
        uint256 supply;
        uint256 totalBorrowedAmount;
        mapping(address => uint256) collateralBalance;
        bool canBorrow;
        uint256 allowedBorrowAmount;
        address[] suppliedCollaterAssets;
    }

    mapping(address => USER) public users;

    CometInterface public comet;
    CometRewards public rewards;
    // DelegateCallHandler public delegateCallHandler;

    constructor(address _cometProxy, address _rewardsAddr) payable {
        require(_cometProxy!= address(0), "Comet proxy address cannot be zero");
        require(_rewardsAddr!= address(0), "Rewards address cannot be zero");
        console.log(msg.sender);

        comet = CometInterface(_cometProxy);
        rewards = CometRewards(_rewardsAddr);
       
    }

    function addLender(address lender) public {
        require(msg.sender == lender, "Only the lender can add themselves");
        require(!users[lender].canBorrow, "Lender already added");
        users[lender].canBorrow = true;
    }

    function addBorrower(address borrower) public {
        require(msg.sender == borrower, "Only the borrower can add themselves");
        require(!users[borrower].canBorrow, "Borrower already added");
        users[borrower].canBorrow = true;
    }

    function supplyCollateral(address token, uint256 amount) external {
        IERC20(token).transferFrom(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, address(this), amount+1000); // tx.origin for production env't
        IERC20(token).approve(address(comet), amount);
        comet.supply(token, amount);
        USER storage user = users[msg.sender];
        user.supply += amount;
        user.collateralBalance[token] += amount;
        user.suppliedCollaterAssets.push(address(token));
    }

    function isBorrowAllowed() public view returns(bool) {
        return comet.isBorrowCollateralized(msg.sender);

    }




    function getTotalSuppliedAmount(address user) public view returns(uint) {

        uint totalSupplied;

        for(uint256 i; i< users[user].suppliedCollaterAssets.length; i++){
            totalSupplied += comet.getCollateralReserves(users[user].suppliedCollaterAssets[i]);
            
            
            }

            return totalSupplied;
         
       



    }



    function getTotalBorrowedAmount(address account) public view returns(uint) {
        return comet.borrowBalanceOf(account);
    }

    function borrowAssets(uint256 amount) external {
        require(users[msg.sender].canBorrow, "User cannot borrow");
        require(amount <= users[msg.sender].allowedBorrowAmount, "Exceeds borrowing limit");

        // Check if USDC is part of the collateral and prioritize its withdrawal
        IERC20 usdcToken = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F); // Example USDC address
        uint256 usdcAmount = users[msg.sender].collateralBalance[address(usdcToken)];
        if (usdcAmount > 0) {
            // Withdraw USDC first
            usdcToken.transferFrom(msg.sender, address(this), usdcAmount);
            users[msg.sender].collateralBalance[address(usdcToken)] -= usdcAmount;
            users[msg.sender].supply -= usdcAmount;
        }

        // Proceed with borrowing USDC for the eligible collateral value
        // Implement the logic to calculate the eligible collateral value and borrow accordingly
        // This is a placeholder for the actual borrowing logic
        users[msg.sender].totalBorrowedAmount += amount;
    }

    // Additional functions as needed

    // function isLiquidatable() public returns (bool) {
    //     return comet.isLiquidatable(tx.origin);
    // }

    // function BuyCollateral(address _asset, uint256 usdcAmount) public {
    //     IERC20(USDCBase).transferFrom(tx.origin, address(this), usdcAmount);
    //     IERC20(USDCBase).approve(address(comet), usdcAmount);
    //     comet.buyCollateral(_asset, 0, 1, tx.origin);
    // }
}
