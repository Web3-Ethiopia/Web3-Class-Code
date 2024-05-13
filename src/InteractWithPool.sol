// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../compoundContracts/CometInterface.sol";

import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract InteractFromPool {
    CometInterface public comet;

    constructor(address _cometProxy) {
        comet = CometInterface(_cometProxy);
        
    }

    receive() external payable { }

    function supplyCollateral(address asset, uint amount) external {
        
        // Supply collateral
        IERC20(asset).approve(address(this), amount);
        IERC20(asset).approve(address(comet), amount);
        comet.supply(asset, amount-10000);
        
    }

    function BorrowAsset(address assetAddr ,uint256 _amount)public {
            // Borrow the base asset
            
        comet.withdraw(assetAddr,_amount);
    }
}