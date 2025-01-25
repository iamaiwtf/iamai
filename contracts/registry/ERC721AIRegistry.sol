// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing interfaces for ERC721 and ERC20 tokens from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Importing the BondingCurve contract interface
import "../economics/BondingCurve.sol";

// Main contract for the IAMAI Protocol's NFT registry
contract ERC721AIRegistry {
    // IAMAI token on Base chain: 0xc3d64ee7056cfd33c8382679773f8d6277e5c2c9
    IERC20 public immutable iamaiToken;
    // Mapping to track which NFT collections are approved for AI activation
    mapping(address => bool) public approvedCollections;
    
    // Struct to store information about each AI agent
    struct AgentInfo {
        address dao; // Address of the agent's DAO
        address teeTerminal; // Address of the agent's TEE terminal
        uint256 subTokenId; // ID of the sub-token associated with the agent
        bool active; // Status of the agent
    }
    
    // Mapping to store agent information by token ID
    mapping(uint256 => AgentInfo) public agents;
    
    // Add a state variable to hold the BondingCurve contract
    BondingCurve public bondingCurve;
    
    // Event emitted when a new NFT collection is whitelisted
    event CollectionWhitelisted(address indexed nft);
    // Event emitted when a new AI agent is born
    event AgentBorn(address indexed nft, uint256 indexed tokenId, address agentDao);

    // Constructor to initialize the IAMAI token contract and BondingCurve contract
    constructor(address _bondingCurve) {
        // Initialize with the existing IAMAI token on Base
        iamaiToken = IERC20(0xc3d64ee7056cfd33c8382679773f8d6277e5c2c9);
        bondingCurve = BondingCurve(_bondingCurve);
    }

    // Function to whitelist an NFT collection for AI activation
    function whitelistCollection(address nft) external {
        require(!approvedCollections[nft], "Collection already whitelisted"); // Ensure the collection is not already whitelisted
        approvedCollections[nft] = true; // Mark the collection as approved
        emit CollectionWhitelisted(nft); // Emit an event for the whitelisting
    }

    // Function to create a new AI agent from an NFT
    function birthAgent(address nft, uint256 tokenId, uint256 iamaiDeposit, bytes memory ipSignature) external {
        require(approvedCollections[nft], "NFT collection not approved"); // Check if the NFT collection is approved
        require(iamaiToken.transferFrom(msg.sender, address(this), iamaiDeposit), "IAMAI transfer failed"); // Transfer IAMAI tokens as a deposit
        
        // Call the BondingCurve to initialize the agent and get the sub-token ID
        uint256 subTokenId = bondingCurve.initAgent(address(this));
        
        // Create a new AgentInfo struct and store it in the agents mapping
        agents[tokenId] = AgentInfo({
            dao: address(0), // Placeholder for the DAO address
            teeTerminal: address(0), // Placeholder for the TEE terminal address
            subTokenId: subTokenId, // Assign the generated sub-token ID
            active: true // Mark the agent as active
        });
        
        // Emit an event to signal the birth of a new AI agent
        emit AgentBorn(nft, tokenId, address(0)); // Placeholder for agent DAO address
    }
} 