// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";

/**
 * @title AgentDAO
 * @notice Governance contract for individual AI agents in the IAMAI Protocol
 * @dev This contract implements OpenZeppelin's Governor system with the following features:
 * - AID token-weighted voting
 * - Timelock for execution delay
 * - Quorum requirements
 * - NFT buyback proposals
 *
 * From the whitepaper:
 * - Manages the agent's treasury (15% from trades)
 * - Controls brand decisions and expansions
 * - Guides the path to autonomy via NFT buyback
 * - Enables community participation in agent development
 */
contract AgentDAO is 
    Governor, 
    GovernorSettings, 
    GovernorCountingSimple, 
    GovernorVotes, 
    GovernorVotesQuorumFraction,
    GovernorTimelockControl
{
    // Core protocol references
    address public immutable terminal;    // Agent's TEE interface
    uint256 public immutable agentId;     // Registry identifier
    IERC20 public immutable aidToken;     // Agent's governance token
    
    // Events for tracking DAO activities
    event BuybackInitiated(
        uint256 price,
        uint256 proposalId,
        uint256 timestamp
    );
    event BuybackExecuted(
        uint256 proposalId,
        uint256 timestamp
    );
    event TreasuryAction(
        string action,
        uint256 amount,
        address target
    );
    
    /**
     * @notice Initializes the DAO with core parameters
     * @dev Sets up governance timeframes and voting requirements
     * @param _token The AID token used for voting power
     * @param _terminal Agent's TEE terminal address
     * @param _agentId Unique identifier from registry
     * @param _timelock Controller for delayed execution
     */
    constructor(
        IVotes _token,
        address _terminal,
        uint256 _agentId,
        TimelockController _timelock
    ) 
        Governor("AgentDAO") 
        GovernorSettings(
            1,          // 1 block voting delay
            45818,      // ~1 week voting period (assuming 13s blocks)
            0           // No minimum token threshold for proposals
        )
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)    // 4% quorum requirement
        GovernorTimelockControl(_timelock)
    {
        require(_terminal != address(0), "Invalid terminal");
        terminal = _terminal;
        agentId = _agentId;
        aidToken = IERC20(address(_token));
    }
    
    /**
     * @notice Creates a proposal to buy back the agent's NFT
     * @dev This is a key step toward agent autonomy
     * @param price The proposed price for the NFT buyback
     * @return proposalId The ID of the created proposal
     */
    function proposeBuyback(uint256 price) external returns (uint256) {
        // Prepare the buyback call
        bytes memory callData = abi.encodeWithSignature(
            "executeBuyback(uint256)",
            price
        );
        
        // Create arrays for proposal
        address[] memory targets = new address[](1);
        targets[0] = terminal;
        uint256[] memory values = new uint256[](1);
        values[0] = 0;
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = callData;
        
        // Submit the proposal
        uint256 proposalId = propose(
            targets,
            values,
            calldatas,
            "NFT Buyback Proposal"
        );
        
        emit BuybackInitiated(price, proposalId, block.timestamp);
        return proposalId;
    }
    
    // Required overrides for the Governor system
    // These ensure proper functionality of the governance mechanism
    
    function votingDelay()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingDelay();
    }

    function votingPeriod()
        public
        view
        override(IGovernor, GovernorSettings)
        returns (uint256)
    {
        return super.votingPeriod();
    }

    function quorum(uint256 blockNumber)
        public
        view
        override(IGovernor, GovernorVotesQuorumFraction)
        returns (uint256)
    {
        return super.quorum(blockNumber);
    }

    function state(uint256 proposalId)
        public
        view
        override(Governor, GovernorTimelockControl)
        returns (ProposalState)
    {
        return super.state(proposalId);
    }

    function propose(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        string memory description
    ) public override(Governor, IGovernor) returns (uint256) {
        return super.propose(targets, values, calldatas, description);
    }

    function _execute(
        uint256 proposalId,
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
        emit BuybackExecuted(proposalId, block.timestamp);
    }

    function _cancel(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory calldatas,
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
        return super._cancel(targets, values, calldatas, descriptionHash);
    }

    function _executor()
        internal
        view
        override(Governor, GovernorTimelockControl)
        returns (address)
    {
        return super._executor();
    }
} 