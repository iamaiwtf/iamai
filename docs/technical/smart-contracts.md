# IAMAI Protocol Smart Contracts

## Overview

The IAMAI Protocol smart contracts enable NFTs to evolve into AI agents with their own token economies and DAOs. This technical documentation covers the core smart contract implementations and their interactions.

## Core Components

### 1. Registry System (`ERC721AIRegistry.sol`) ✅
- Core registry for AI agent creation
- Handles NFT collection whitelisting
- Manages agent lifecycle and permissions
- Status: Implemented and ready for testing

### 2. Economic Engine (`BondingCurve.sol`) ✅
- Implements agent-specific sub-tokens (AID)
- Manages bonding curve mechanics
- Handles treasury allocations (5% burn, 15% treasury)
- Status: Implemented and ready for testing

### 3. Agent Terminal (`AgentTerminal.sol`) ✅
- TEE integration for secure AI operations
- Handles secure computations and verifications
- Manages treasury funding requests
- Status: Implemented and ready for testing

### 4. Governance (`AgentDAO.sol`) ✅
- Individual agent DAOs
- Treasury management
- NFT buyback proposals
- Status: Implemented and ready for testing

## Implementation Status

| Component | Status | Description |
|-----------|--------|-------------|
| Registry | ✅ | Implementation complete |
| Bonding Curve | ✅ | Implementation complete |
| Agent Terminal | ✅ | Implementation complete |
| Agent DAO | ✅ | Implementation complete |
| Tests | 🏗️ | Reference implementations provided |
| Documentation | ✅ | Core docs complete |

Legend: ✅ Complete | 🏗️ In Progress | 📝 Planned

## Contract Dependencies

The protocol currently depends only on:
```json
{
  "dependencies": {
    "@openzeppelin/contracts": "^5.2.0"
  }
}
```

## Testing

The `test/` directory contains reference test cases for each contract. These test specifications can be implemented using any testing framework (Hardhat, Foundry, etc.).

Key test areas:
1. Registry operations
2. Bonding curve mechanics
3. DAO governance
4. Security & permissions

## Development Guidelines

1. **Security First**
   - All contracts inherit from OpenZeppelin standards
   - Strict access control implementation
   - Comprehensive test coverage required

2. **Modularity**
   - Contracts are designed to be modular
   - Clear separation of concerns
   - Upgradability considerations built-in

3. **Gas Optimization**
   - Efficient storage patterns
   - Batch operations where possible
   - Minimal contract dependencies

## Contributing

1. Review the existing implementations
2. Follow the test specifications
3. Submit improvements via pull requests
4. Join community discussions for major changes

## Next Steps

1. Complete core contract implementations
2. Add comprehensive test coverage
3. Deploy to testnet for community testing
4. Gather feedback for improvements

## Security Considerations

1. **Access Control**
   - Role-based permissions
   - Admin functionality restrictions
   - Emergency pause mechanisms

2. **Economic Security**
   - Bonding curve parameters
   - Treasury management
   - NFT buyback protections

3. **Integration Points**
   - NFT ownership verification
   - Token transfer safety
   - External contract interactions 