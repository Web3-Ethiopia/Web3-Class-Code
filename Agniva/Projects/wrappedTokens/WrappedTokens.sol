// SPDX-License-Identifier: MIT
pragma solidity 0.8.0-0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

interface IMainToken is IERC20{

}

contract wWEB3ETH is ERC20, Ownable{
    
    address public liquidityFeeWallet;
    address public mainCoinAddress;
    address public mainWSupplyHandler;
    address public wrappedSupplyHandler;
    IMainToken public token;

    constructor(address _wrappedSupplyHandler ,address _mainAddress, address _mainWSupplyHandler) ERC20("Web3Foundation","wWEB3ETH") Ownable(_msgSender()){
        mainCoinAddress=_mainAddress;
        token = IMainToken(_mainAddress);
        mainWSupplyHandler=_mainWSupplyHandler;
        _mint(_wrappedSupplyHandler, token.balanceOf(_mainWSupplyHandler));
        liquidityFeeWallet=msg.sender;
        wrappedSupplyHandler=_wrappedSupplyHandler;
        
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

    function adjustSupply() public onlyOwner{
        require(token.balanceOf(mainWSupplyHandler)!= totalSupply(),"Supply hasnt changed");
        if(token.balanceOf(mainWSupplyHandler)> totalSupply()){
            
        _mint(wrappedSupplyHandler, token.balanceOf(mainWSupplyHandler)-totalSupply());
        }else{
        _burn(wrappedSupplyHandler, totalSupply()-token.balanceOf(mainWSupplyHandler));
        }
    }

}