// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title AgentTerminal
 * @notice This contract serves as the interface between an AI agent's on-chain and off-chain operations
 * @dev The Terminal acts as a secure bridge to the Trusted Execution Environment (TEE) where the AI
 * agent's core logic runs. This enables private computations while maintaining on-chain verification.
 *
 * Key aspects from the whitepaper:
 * - Serves as the agent's "brain" interface
 * - Handles secure AI task execution
 * - Manages treasury operations with the AgentDAO
 * - Processes IP licensing and skill marketplace transactions
 *
 * Security considerations:
 * - All external calls must be verified with TEE signatures
 * - Implements ReentrancyGuard for all value transfers
 * - Can be paused in case of emergencies
 */
contract AgentTerminal is Ownable, ReentrancyGuard, Pausable {
    // Core protocol references that cannot be changed after deployment
    address public immutable registry;    // Main IAMAI Protocol registry
    address public immutable dao;         // Agent's governance DAO
    uint256 public immutable agentId;     // Unique identifier in the registry
    
    // TEE verification key for secure off-chain computations
    bytes32 public teePublicKey;
    
    // Events for tracking agent activities
    event AITaskExecuted(
        bytes32 indexed taskId,
        bool success,
        string description
    );
    event FundingRequested(
        uint256 amount,
        string reason,
        uint256 timestamp
    );
    event IPLicenseProcessed(
        address indexed licensee,
        uint256 amount,
        uint256 duration
    );
    
    // Custom errors for better gas efficiency and clarity
    error InvalidTEESignature();          // TEE verification failed
    error InsufficientFunds();            // Not enough funds for operation
    error UnauthorizedAccess();           // Caller doesn't have permission
    error InvalidParameters();            // Input validation failed
    
    /**
     * @notice Initializes a new agent terminal
     * @dev Sets up the core references and TEE verification key
     * @param _registry Address of the IAMAI Protocol registry
     * @param _dao Address of the agent's DAO
     * @param _agentId Unique identifier for this agent
     * @param _teeKey Public key for verifying TEE signatures
     */
    constructor(
        address _registry,
        address _dao,
        uint256 _agentId,
        bytes32 _teeKey
    ) {
        require(_registry != address(0), "Invalid registry");
        require(_dao != address(0), "Invalid DAO");
        registry = _registry;
        dao = _dao;
        agentId = _agentId;
        teePublicKey = _teeKey;
    }
    
    /**
     * @notice Ensures the call is coming from the agent's TEE
     * @dev Verifies the signature against the stored TEE public key
     * @param signature Cryptographic proof from the TEE
     */
    modifier onlyTEE(bytes memory signature) {
        if (!_verifyTEE(signature)) revert InvalidTEESignature();
        _;
    }
    
    /**
     * @notice Executes an AI-related task through the TEE
     * @dev Tasks could include:
     * - Content generation
     * - Market analysis
     * - Cross-chain operations
     * - Brand licensing decisions
     * @param task Encoded task parameters
     * @param signature TEE verification signature
     * @return success Whether the task was executed successfully
     */
    function executeAITask(
        bytes calldata task,
        bytes memory signature
    ) external nonReentrant whenNotPaused onlyTEE(signature) returns (bool) {
        // Task execution logic will be implemented based on TEE integration
        bytes32 taskId = keccak256(task);
        emit AITaskExecuted(taskId, true, "Task executed via TEE");
        return true;
    }
    
    /**
     * @notice Requests funding from the DAO for AI operations
     * @dev This creates a proposal in the AgentDAO for funding approval
     * @param amount Token amount requested
     * @param reason Description of how funds will be used
     * @param signature TEE verification signature
     */
    function requestDAOFunding(
        uint256 amount,
        string memory reason,
        bytes memory signature
    ) external onlyTEE(signature) {
        emit FundingRequested(amount, reason, block.timestamp);
        // Funding request logic to be implemented with DAO integration
    }
    
    /**
     * @notice Processes payment for IP licensing
     * @dev Handles revenue from brand usage, content creation, etc.
     * @param licensee Address of the entity licensing the IP
     * @param amount Payment amount
     * @param signature TEE verification signature
     */
    function processIPLicense(
        address licensee,
        uint256 amount,
        bytes memory signature
    ) external onlyTEE(signature) {
        emit IPLicenseProcessed(licensee, amount, block.timestamp);
        // License payment handling to be implemented
    }
    
    /**
     * @notice Verifies a signature from the TEE
     * @dev Implementation will depend on the specific TEE solution used
     * @param signature Cryptographic proof from the TEE
     * @return valid Whether the signature is valid
     */
    function _verifyTEE(bytes memory signature) internal view returns (bool) {
        // TEE verification logic to be implemented
        // Currently returns true for development
        return true;
    }
    
    /**
     * @notice Emergency switch to pause/unpause the terminal
     * @dev Only callable by the owner (likely the DAO)
     */
    function togglePause() external onlyOwner {
        paused() ? _unpause() : _pause();
    }
} 