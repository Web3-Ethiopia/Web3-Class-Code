// SPDX-License-Identifier: MIT
pragma solidity 0.8.0-0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";


contract WEB3ETH is ERC20{
    address public liquidityFeeWallet;
    address public wrappedSupplyHandler;
    address public liquidityReserves;
    address public wLiquidityReserve;

    constructor( address liquidityFeesWallet1,address _wrappedSupplyHandler, address _liquidityReserves) ERC20("Web3Foundation","WEB3ETH"){
        _mint(_msgSender(), 1000 * 10**18);
        liquidityFeeWallet=liquidityFeesWallet1;
        wrappedSupplyHandler=_wrappedSupplyHandler;
        liquidityReserves=_liquidityReserves;
    }

    function transfer(address to, uint256 value) public override returns (bool) {
       
        address owner = _msgSender();
        require(value<super.balanceOf(owner),"Not enough balance");
        uint256 theFeeValue=value - value * 90/100;
        uint256 theTransactionAmount=value-theFeeValue;
        require(theFeeValue>0,"The fees are 0");
        console.log(theTransactionAmount);
        console.log(theFeeValue);
        super._transfer(owner, to, theTransactionAmount);
        super._transfer(owner, liquidityFeeWallet, theFeeValue);
        return true;
    }

    function transferNormal(address to, uint256 value) public {
        (bool success)=super.transfer(to, value);
        require(success,"funds transfered");

    }

    function updateReserves(address stableTokenAddress) public {
        IERC20 token = IERC20(stableTokenAddress);
        uint256 totalLiquidityBalance=token.balanceOf(liquidityReserves);
        uint256 wrappedSupplyShare=balanceOf(wrappedSupplyHandler)/totalSupply()*100;
        token.transferFrom(liquidityReserves,wLiquidityReserve, totalLiquidityBalance*wrappedSupplyShare/100);
    }


}