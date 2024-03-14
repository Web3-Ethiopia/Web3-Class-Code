# Ethereum Smart Contracts for DAO and Call Demonstrations

This repository contains a collection of Ethereum smart contracts designed to illustrate various call operations and to implement a simple Decentralized Autonomous Organization (DAO) with a focus on voting and wallet management.

## Overview

The project is divided into two main sections: Call Contracts and DAO Components. The Call Contracts section showcases different methods of contract interactions such as `call`, `delegateCall`, and `staticCall`. The DAO Components section includes contracts for a voting system, a Web3 integration example, and wallet contracts, all essential for running a simple DAO.

## Call Contracts

### `call.sol`

- Demonstrates the use of the `call` method for invoking functions and sending Ether between contracts.

### `delegateCall.sol`

- Shows how `delegateCall` can execute another contract's function in the context of the calling contract, allowing for shared logic in a library-like manner.

### `staticCall.sol`

- Utilizes `staticCall` for making external calls that read state without changing it.

### `LibraryDelegateCall.sol`

- Illustrates the use of `delegateCall` within a library setup to leverage shared contract functionality.

### `stateVariablesDelegate.sol`

- Explores interactions with state variables using `delegateCall`, highlighting potential uses and pitfalls.

## DAO Components

### `VotingSystem.sol`

- Implements a voting mechanism for proposal management within the DAO, enabling tier based voting.

### `WEB3ETH.sol`

- Provides an example of an ERC-20 Token with overriding transfer function

### `SimpleWallet.sol`

- A basic wallet contract for managing funds within the DAO.

### `ModifiedMultisig.sol` & `SimpleMultisig.sol`

- Two variations of multisig wallet contracts that add security and require consensus for transactions, aligning with the DAO's governance model.

## Usage

Copy the folder in remix. Compiling only head level contracts

## Dependencies

- Solidity ^0.8.0 (or specify the version used in the contracts)
- Importing openzepplin might be required for some contracts although most of them carry import statements.

## Maintaining a branch

Use your discord Ids' as branch name. The structure for now goes as follows:
Projects -> _ProjectName_ -> _Contracts_.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
