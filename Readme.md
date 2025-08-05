# 🗳️ Aptos Voting System with History & Governance Analytics

## 📄 Project Description

This project is a smart contract module written in the **Move language** for the **Aptos blockchain**, implementing a robust on-chain voting system. It supports:
- Casting votes on predefined proposals
- Tracking who voted for what
- Viewing total participation and voting results
- Enabling governance analytics for communities and DAOs

The module is secure, auditable, and uses Aptos's resource model to ensure transparency and prevent double voting.

## 🌟 Vision

The aim is to build **transparent and traceable on-chain governance** that empowers decentralized communities by:
- Enabling one-vote-per-user enforcement
- Making historical participation verifiable
- Laying the foundation for decentralized reputation systems

This ensures greater engagement, trust, and data-driven decision-making in DAOs.

## 🔑 Key Features

- ✅ **Voting Initialization**
  - Allows a voting authority (admin) to initialize a new poll with hardcoded proposals.
  - Initializes proposal list and vote count per option.

- 🗳️ **One-User-One-Vote Enforcement**
  - Prevents double voting using a resource-bound `Table<address, u8>`.

- 🧾 **Vote History Tracking**
  - Each voter's selected proposal is stored for future lookup.

- 📊 **Governance Analytics**
  - Total number of voters (`total_voters`)
  - Votes per proposal
  - Leading proposal with vote count

- 🔍 **Read-only View Functions**
  - `get_vote_counts` - proposal-wise vote breakdown
  - `get_vote_by_user` - see what a user voted for
  - `get_proposals` - list of all proposal names
  - `get_results` - full result breakdown
  - `get_total_participants` - count of all voters
  - `get_winner` - proposal with most votes

- 🔐 **Security**
  - Error handling with custom error codes
  - Resource-based ownership (prevents unauthorized modifications)

## 🔮 Future Scope

- 🌐 **Frontend Dashboard**
  - A React dashboard that interacts with on-chain data via Aptos SDK and displays analytics in real-time.

- 🎖️ **Reputation Systems**
  - Track long-term participation and reward active voters with badges or privileges.

- 🎁 **Incentive Mechanism**
  - Airdrop tokens or NFTs to voters as rewards for consistent participation.

- 🔗 **Multi-Poll Support**
  - Extend to support multiple simultaneous polls (voting rounds) under the same admin.

- ⛓️ **Cross-DAO Analytics**
  - Aggregate and visualize governance data from multiple modules/contracts.

## 🚀 Getting Started

### 🧰 Prerequisites

- Aptos CLI installed
- Local testnet or Devnet access

## Contract Details
0xb229320ed03f6b9c875f88a428e19a32dd18d237f1a22c8e965d05299808db72

![alt text](<Screenshot (205).png>)

