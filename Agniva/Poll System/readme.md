# Voting System Smart Contract

## Overview

The Voting System smart contract is designed to facilitate secure and transparent voting within the Ethereum blockchain. This contract allows for the creation of polls, voting on polls, and viewing poll results. It incorporates features for tier-based access or privileges based on the token balance of users, utilizing a custom token contract (`WEB3ETH`) for balance checks.

## Features

- **Poll Creation**: Users can create polls with a question and multiple choice options.
- **Voting**: Users can vote on polls. Each address can vote only once per poll to ensure fairness.
- **Poll Details**: Users can view poll questions, options, and the current vote counts for each option.
- **Tier System**: The contract categorizes users into tiers (`gold`, `silver`, `bronze`) based on their token balance. This tier system can be integrated with specific functionalities or access rights within the contract or DApp.
- **Events**: The contract emits events for poll creation, voting, and user tier checks, which can be used by front-end applications for real-time updates or notifications.

## Contract Functions

### Constructor

- Initializes the `WEB3ETH` token contract with specified parameters for minting tokens and handling liquidity fees.

### createPoll

- Creates a new poll with a given question and options.
- Emits a `PollCreated` event.

### vote

- Allows a user to vote on a specific poll option.
- Validates that the poll exists, the user has not already voted, and the chosen option is valid.
- Emits a `Voted` event.

### getPoll

- Returns details of a specific poll, including the question, options, and vote counts for each option.

### checkUserTier

- Checks the calling user's token balance and assigns them a tier based on predefined balance ranges.
- Emits a `TierChecked` event indicating the user's tier.

### balanceCheck

- Returns the token balance of the calling user.

## Events

- **PollCreated**: Emitted when a new poll is created.
- **Voted**: Emitted when a vote is cast in a poll.
- **TierChecked**: Emitted when a user's tier is checked and assigned.

## How to Interact with the Contract

Interaction with the Voting System contract can be done through any Ethereum client library such as web3.js, ethers.js, or directly through a web interface using MetaMask or similar Ethereum wallets. Here are the basic steps:

1. **Deploy the Contract**: Deploy the Voting System contract to an Ethereum network (mainnet, testnet, or local blockchain).
2. **Interact with Functions**: Use the contract's functions (`createPoll`, `vote`, `getPoll`, `checkUserTier`, etc.) to interact with the contract. Ensure you handle Ethereum transactions and gas fees accordingly.
3. **Listen for Events**: Implement event listeners in your DApp to react to emitted events for real-time updates.

## Important Notes

- Ensure that you have adequate ETH in your account to cover transaction fees.
- Always test your contract thoroughly on a testnet before deploying to the mainnet.

---

Please adjust the content to fit your project's specific needs or details.