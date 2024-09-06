# Staking Contract

## Overview

This project implements a staking contract in Solidity that allows users to stake ERC20 tokens and earn rewards over time. The backend service uses Node.js with Express to fetch staking data from the Ethereum blockchain via Alchemy.

### Smart Contract Features:

- Stake tokens and earn rewards
- Withdraw staked tokens
- Claim accumulated rewards
- Admin functionality to set reward rates and deposit rewards

### Backend Features:

- Fetch staking data by user address using Alchemy’s JSON-RPC API
- Expose API endpoints for the frontend to retrieve staking data

## Getting Started

### Prerequisites

- Node.js
- Alchemy API Key
- Ethereum Wallet with Sepolia test tokens (or applicable network tokens)

### Smart Contract

1. **Deploy Contract**
   - The contract uses OpenZeppelin libraries for access control and security.
   - Set the reward rate and staking/reward tokens upon deployment.

### Install Dependencies

1. Clone the repo:

   ```bash
   git clone <repo-url>
   cd <project-directory>
   ```

2. Install dependencies:

   ```bash
    npm install
   ```

3. Create a `.env` file in the root directory and add the following environment variables:

   ```bash
   ALCHEMY_API_KEY=<your-alchemy-api>
   STAKING_CONTRACT_ADDRESS=<your-staking-contract-address>
   ```

4. Start the backend service:
   ```bash
   npm run start
   ```
