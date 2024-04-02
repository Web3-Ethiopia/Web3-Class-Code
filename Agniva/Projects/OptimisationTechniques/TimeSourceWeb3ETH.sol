// SPDX-License-Identifier: MIT
pragma solidity 0.8.0-0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";

interface ITimeSource {
    struct TimeData{
        uint256 timeStamp;
        string Date;
        string OracleTime;
    }

    struct TransactionOrder{
        uint64 timeStamp;
        string transactionData;
        TimeData timeDetails;
    }

    function getTransactionQueue() external  returns (string[] memory);
    function postTransaction(TransactionOrder memory _transaction) external  returns (bool);
    function getTimeBasedOrders() external  returns (TransactionOrder memory);
    function getTimeDetails() external  returns (TransactionOrder memory);
}

 contract TimeOrderBook is ITimeSource, Ownable{
    
    mapping(address=>TransactionOrder) public transactionWallets;
    mapping(uint256=>bytes) public TimeBasedOrders;
    // address private owner;
    
    constructor() Ownable(msg.sender){
        // owner=msg.sender;
    }

    function getTransactionQueue() public pure returns(string[] memory) {
        string[] memory emptyStringArray;
        return emptyStringArray;
    }
    function postTransaction(TransactionOrder memory _transaction) public   returns(bool) {
        transactionWallets[msg.sender].timeStamp=_transaction.timeStamp;
        transactionWallets[msg.sender].transactionData=_transaction.transactionData;
        TimeBasedOrders[block.timestamp]=bytes(_transaction.transactionData);
        return true; 
    }
    function getTimeBasedOrders() public pure returns(TransactionOrder memory) {
        TransactionOrder memory TransactionOrderd;
        return TransactionOrderd;
    }
    function getTimeDetails() public view returns(TransactionOrder memory){
        //  TransactionOrder memory TransactionOrderd;
        
    
        return transactionWallets[msg.sender];
    }
}