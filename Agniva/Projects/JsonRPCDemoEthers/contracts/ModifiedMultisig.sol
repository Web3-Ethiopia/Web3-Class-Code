// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 value) external  returns (bool);
    function totalSupply() external view returns (uint256);
}

contract EnhancedMultisigWallet {
    address[] public owners;
    uint public requiredApprovals;

    //add** Make an event for proposals submitted along with their required info

    struct Transaction {
        address to;
        uint value;
        address tokenAddress; 
        bool executed;
        uint approvalCount;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approvals;

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

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    constructor(address[] memory _owners, uint _requiredApprovals) payable {
        require(_owners.length > 0, "Owners required");
        require(_requiredApprovals > 0 && _requiredApprovals <= _owners.length, "Invalid number of required approvals");
        owners = _owners;
        requiredApprovals = _requiredApprovals;
    }

    
    function submitTransaction(address _to, uint _value) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            tokenAddress: address(0),
            executed: false,
            approvalCount: 0
        }));
    }

    function submitTransactionWithTokenAdress(address _to, uint _value, address _tokenAddress) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value * 10**18,
            executed: false,
            approvalCount: 0,
            tokenAddress: _tokenAddress
            
        }));
    }

    function approveTransaction(uint _txIndex) public payable  onlyOwner notExecuted(_txIndex) {
        // Transaction storage transaction = transactions[_txIndex];
        // IERC20 token=IERC20(transaction.tokenAddress);

        require(!approvals[_txIndex][msg.sender], "Transaction already approved");

        approvals[_txIndex][msg.sender] = true;
        transactions[_txIndex].approvalCount++;

        if (transactions[_txIndex].approvalCount >= requiredApprovals) {
            executeTransaction(_txIndex);
        }
    }

    function executeTransaction(uint _txIndex) private notExecuted(_txIndex) {
        Transaction storage transaction = transactions[_txIndex];
        require(transaction.approvalCount >= requiredApprovals, "Insufficient approvals");

        transaction.executed = true;

        if (transaction.tokenAddress == address(0)) {
            // Ether transfer
            (bool success,) = transaction.to.call{value: transaction.value}("");
            console.log(success);
            require(success, "Transaction failed");
            // assert(success!=false);
        } else {
            IERC20 token = IERC20(transaction.tokenAddress);
            bool success = token.transfer(transaction.to, transaction.value);
            require(success, "Token transfer failed");
            
        }
    }

    function setRequiredApprovals(uint approvalCount) public onlyOwner {
        requiredApprovals=approvalCount;
    } 

    receive() external payable {}

    function getBalance() public view returns (uint) {
        require(address(this).balance>0,"not enough balance");
        return address(this).balance;
    }

    // New function to get the balance of ERC20 tokens
    // function getTokenBalance(address _tokenAddress) public view returns (uint) {
    //     IERC20 token = IERC20(_tokenAddress);
    //     return token.balanceOf(address(this));
    // }

    //add** require statements for unavailable data.

    function getTokenBalance(address _tokenAddress) public view returns (uint) {
         IERC20 token = IERC20(_tokenAddress);
        // require(token.balanceOf(address(this))>0,"not enough token balance");
        return token.balanceOf(address(this));
    }
}
