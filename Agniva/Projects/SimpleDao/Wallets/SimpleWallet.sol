// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/CoinVest.sol";
import "hardhat/console.sol";

contract SimpleWalletContract {
    address public owner;
    WEB3ETH public TokenContract;
    address[] public preferredSendingAddresses;


    event Deposit(address indexed sender, uint256 value);
    event Withdraw(address indexed to, uint256 value);

   

    constructor( address liquidityAddress){
        owner=msg.sender;
        TokenContract=new WEB3ETH(owner,liquidityAddress);
      
    }

     modifier onlyOwner(){
        require(msg.sender==owner,"Only allowed for owners");
        _;
    }

    function Deposited(uint256 _amount) public payable {
        require(_amount<owner.balance,"Not enough balance");
        emit Deposit(msg.sender, msg.value);
    }

     function Withdrawit(uint256 _amount,address withdrawlAddress) public onlyOwner {
        // require(_amount<TokenContract.balanceOf(owner),"Not enough balance");
        TokenContract.approve(address(this), 500);
        console.log(TokenContract.balanceOf(owner));
        TokenContract.transfer(withdrawlAddress,_amount);
        
        
        emit Withdraw(msg.sender, _amount);
        // return TokenContract.balanceOf(owner);
    }

    function checkAssembly()
        external
        payable
    {
        assembly {
            let masterCopy := and(sload(0), 0xffffffffffffffffffffffffffffffffffffffff)
            calldatacopy(0, 0, calldatasize())
            let success := delegatecall(not(0), masterCopy, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch success
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    function BalanceOf(address addressBalance)public view returns (uint){
        return TokenContract.balanceOf(addressBalance);
    }
}


// interface ISimpleWallet{
//     function Deposited(address) external returns(bool);
// }

// contract Caller {
//     function callSetValue(address _callee, uint _value) public {
//         // Callee contract is being called here
//         (bool success, ) = _callee.call(abi.encodeWithSignature("setValue(uint256)", _value));
//         require(success, "Call failed");
// 