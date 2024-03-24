# AdContract Smart Contract

This repository contains a Solidity smart contract designed for managing advertisement proposals between companies and content creators. The contract facilitates the submission of ad proposals, approval or rejection by creators, and interaction tracking for approved ads.


## Features

- **Creator and Company Registration**: Allows creators and companies to register themselves with a starting reputation.

- **Proposal Submission and Management**: Companies can submit advertisement proposals to creators, specifying the ad content and payment offer. Creators can then approve or reject these proposals.

- **Post Interaction**: Tracks user interactions with posts, allowing for thumbs up or thumbs down responses.

- **Reputation Management**: Updates reputations for creators and companies based on proposal approvals and successful ad campaigns.


## Events

- `CreatorRegistered`
- `CompanyRegistered`
- `ProposalSubmitted`
- `PaymentTransferred`
- `PostInteraction`
- `ProposalRejected`
- `ProposalApproved`


## Functions
- `registerCreator()`: Registers a new creator.
- `registerCompany()`: Registers a new company.
- `submitProposal(string memory adHash, uint256 paymentOffer, address targetCreator)`: Submits a new ad proposal.
- `approveProposal(uint256 proposalId)`: Approves an ad proposal.
- `rejectProposal(uint256 proposalId)`: Rejects an ad proposal.
- `interactWithPost(uint256 proposalId, InteractionType interaction)`: Records an interaction with a post.


## Getting Started

1. Clone the repository and navigate into it:
```bash
git clone https://github.com/marcusats/kanan-contracts
cd kanan-contracts
```

2. Install the dependencies:
```bash
npm install
```

3. Compile the smart contract:
```bash
npx hardhat compile
```


