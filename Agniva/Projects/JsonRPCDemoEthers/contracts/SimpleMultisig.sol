// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

  interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}


contract SimpleMultisigWallet {
    // List of owners and the number of approvals required
    address[] public owners;
    uint public requiredApprovals;

    // Struct for a transaction request
    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint approvalCount;
        address tokenAddress;
    }

    // Array of transactions
    Transaction[] public transactions;

    // Mapping from transaction ID => owner => bool
    mapping(uint => mapping(address => bool)) public approvals;

    // Modifier to check if the caller is an owner
    modifier onlyOwner() {
        bool isOwner = false;
        for (uint i = 0; i < owners.length; i++) {
            if (msg.sender == owners[i]) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not an owner");
        _;
    }

    // Modifier to check if the transaction has not been executed
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    // Constructor to set up owners and the number of required approvals
    constructor(address[] memory _owners, uint _requiredApprovals) {
        require(_owners.length > 0, "Owners required");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "Invalid number of required approvals");

        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    // Function to submit a new transaction request
    function submitTransaction(address _to, uint _value) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            executed: false,
            approvalCount: 0,
            tokenAddress: address(0)
            
        }));
    }

    // function submitTransactionWithTokenAddress(){
        
    // }

    

    // Function for an owner to approve a transaction
    function approveTransaction(uint _txIndex) public onlyOwner notExecuted(_txIndex) {
        require(!approvals[_txIndex][msg.sender], "Transaction already approved");
        
        approvals[_txIndex][msg.sender] = true;
        transactions[_txIndex].approvalCount++;

        if (transactions[_txIndex].approvalCount >= requiredApprovals) {
            executeTransaction(_txIndex);
        }
    }


    // Function to execute a transaction after the required number of approvals have been met
  


function executeTransaction(uint _txIndex) private notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.approvalCount >= requiredApprovals, "Insufficient approvals");

        transaction.executed = true;

        if (transaction.tokenAddress == address(0)) {
            // Ether transfer
            (bool success,) = transaction.to.call{value: transaction.value}("");
            require(success, "Transaction failed");
        } else {
            // ERC20 token transfer
            IERC20 token = IERC20(transaction.tokenAddress);
            bool success = token.transfer(transaction.to, transaction.value);
            require(success, "Token transfer failed");
        }
    } 


    // Function to deposit funds into the wallet
    receive() external payable {}

    // Function to get the balance of the wallet
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}