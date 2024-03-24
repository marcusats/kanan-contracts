// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdContract {
    enum InteractionType { ThumbsUp, ThumbsDown }

    struct Creator {
        address wallet;
        bool isRegistered;
        uint256 reputation;
    }

    struct Company {
        address wallet;
        bool isRegistered;
        uint256 reputation;
    }

    struct Proposal {
        uint256 id;
        address company;
        address targetCreator; 
        string adHash; 
        uint256 paymentOffer; 
        bool isApproved;
    }

    struct Post {
        uint256 id;
        uint256 proposalId;
        uint256 thumbsUp;
        uint256 thumbsDown;
        mapping(address => bool) interactedUsers;
    }

    mapping(address => Creator) public creators;
    mapping(address => Company) public companies;
    mapping(uint256 => Proposal) public proposals;
    mapping(uint256 => Post) private posts;
    mapping(address => uint256[]) private creatorProposals; 
    mapping(address => uint256[]) private creatorPosts; 

    uint256 public nextProposalId = 1;

    event CreatorRegistered(address indexed creator, uint256 reputation);
    event CompanyRegistered(address indexed company, uint256 reputation);
    event ProposalSubmitted(uint256 indexed proposalId, address indexed company, address targetCreator, string adHash, uint256 paymentOffer);
    event PaymentTransferred(address indexed creator, uint256 amount);
    event PostInteraction(uint256 indexed postId, InteractionType interactionType, address user);
    event ProposalRejected(uint256 indexed proposalId, address indexed creator);
    event ProposalApproved( uint256 indexed proposalId, address indexed company,address indexed creator,uint256 companyReputation,uint256 creatorReputation,uint256 paymentAmount);

  
    function registerCreator() public {
        require(!creators[msg.sender].isRegistered, "Creator already registered");
        creators[msg.sender] = Creator(msg.sender, true, 50); // Starting reputation
        emit CreatorRegistered(msg.sender,50);
    }

    function registerCompany() public {
        require(!companies[msg.sender].isRegistered, "Company already registered");
        companies[msg.sender] = Company(msg.sender, true, 50); // Starting reputation
        emit CompanyRegistered(msg.sender, 50);
    }

    // Submit a new advertisement proposal targeting a specific creator
    function submitProposal(string memory adHash, uint256 paymentOffer, address targetCreator) public payable {
        require(msg.value == paymentOffer, "Payment must match the offer");
        require(creators[targetCreator].isRegistered, "Target creator must be registered");
        proposals[nextProposalId] = Proposal(nextProposalId, msg.sender, targetCreator, adHash, paymentOffer, false);
        emit ProposalSubmitted(nextProposalId, msg.sender, targetCreator, adHash, paymentOffer);
        nextProposalId++;
    }

    // Approve an advertisement proposal; only the targeted creator can approve
    function approveProposal(uint256 proposalId) public {
    Proposal storage proposal = proposals[proposalId];
    require(msg.sender == proposal.targetCreator, "Only the targeted creator can approve this proposal");
    require(!proposal.isApproved, "Proposal already completed");

    proposal.isApproved = true; // Marking the proposal as completed

    // Update reputations
    Creator storage creator = creators[msg.sender];
    creator.reputation += 5;
    Company storage company = companies[proposal.company];
    company.reputation += 10;

    // Link this proposal to the creator and initialize a new post (if applicable)
    creatorProposals[msg.sender].push(proposalId);
    Post storage newPost = posts[proposalId];
    newPost.id = proposalId;
    newPost.proposalId = proposalId;
    creatorPosts[msg.sender].push(proposalId);

    // Transfer the payment offer
    payable(msg.sender).transfer(proposal.paymentOffer);

    // Emit an event with all relevant information
    emit ProposalApproved(
        proposalId,
        proposal.company,
        msg.sender,
        company.reputation,
        creator.reputation,
        proposal.paymentOffer
    );
}


    function rejectProposal(uint256 proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        require(msg.sender == proposal.targetCreator, "Only the targeted creator can reject this proposal");
        require(!proposal.isApproved, "Proposal has already been approved or rejected");


        emit ProposalRejected(proposalId, msg.sender);

        payable(proposal.company).transfer(proposal.paymentOffer);
    }


    function interactWithPost(uint256 proposalId, InteractionType interaction) public {
        require(proposals[proposalId].isApproved, "Proposal must be approved");
        Post storage post = posts[proposalId];
        require(!post.interactedUsers[msg.sender], "User has already interacted");
        if (interaction == InteractionType.ThumbsUp) {
            post.thumbsUp++;
        } else {
            post.thumbsDown++;
        }
        post.interactedUsers[msg.sender] = true;
        emit PostInteraction(proposalId, interaction, msg.sender);
    }


    


}