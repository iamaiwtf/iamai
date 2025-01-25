# IAMAI Protocol Architecture

Welcome to the **IAMAI Protocol** technical architecture overview. This document provides a **high-level reference** for how the system's components fit together, explaining each contract's purpose, the overall flow of data, and recommended folder structures. It serves as a foundation for creating a detailed `devplan.md` and for organizing your smart contracts in the appropriate directories.

---

## 1. System Overview

The IAMAI Protocol brings together **NFT activation**, **AI agent creation**, **bonding curves**, **agent DAOs**, and **on-chain IP licensing** into one cohesive ecosystem. Key objectives:

- **NFT-to-AI Activation**: Turn whitelisted NFTs into autonomous AI agents through an on-chain registry.  
- **Bonding Curve Economics**: Each agent mints a sub-token upon birth, with a 20% tax sink and partial burn.  
- **Autonomous Operation**: Agents maintain their own treasury (AgentTerminal), form DAOs, and potentially buy back their underlying NFT.  
- **License & Skills Marketplace** (future expansion): Agents monetize their brand/IP or sell AI-driven services.

### High-Level Diagram (Conceptual)

```
+-------------------+    +--------------------+
| NFT Owner / User  |    | IAMAI Protocol    |
| (front-end)       |    | (Smart Contracts) |
+---------+---------+    +----------+---------+
          |                         |
          | (1) create agent,       |
          |     deposit IAMAI       v
          |              [ ERC721AIRegistry ] --- [ BondingCurve ]
          |                         ^
          |         (2) sub-token   |
          |             minted to   |
          |             user and    |
          |             agent       |
          |                         |
          |         (3) agent       |
          |             deployed    |
          |                         |
          |              [ AgentTerminal ] ---> [ AgentDAO ]
          |              (holds treasury)     (governance)
          |
```

1. **User** calls a function in `ERC721AIRegistry` to activate an NFT as an AI agent.  
2. **BondingCurve** is initialized for this agent, minting a new sub-token for trades.  
3. An **AgentTerminal** contract is deployed to hold funds and eventually tie into an **AgentDAO** for governance.

---

## 2. Core Modules

Below are the **four primary modules** that form the protocol's smart contract backbone. You may also have additional contracts (like IP licensing, skill marketplace, or advanced governance features), but these four represent the minimum required for basic functionality.

### 2.1 ERC721AIRegistry

**Purpose**  
- Whitelists NFT collections that can be activated as AI agents.  
- Binds each minted AI agent to its corresponding NFT.  
- Manages the "birth" process (collecting an IAMAI deposit, distributing tax, minting sub-tokens).

**Key Functions**  
- `birthAgent(...)`: Activates an NFT, references the BondingCurve for sub-token creation, deploys an AgentTerminal, and handles IP assignment signing if needed.  
- `whitelistCollection(...)`: Allows specific NFT collections to become AI-ready, potentially requiring a fee or burn of IAMAI.  
- `buyNFTFromOwner(...)` (optional): Facilitates the agent's eventual buyback of the NFT.

**File Location**  
- `contracts/registry/ERC721AIRegistry.sol`

---

### 2.2 BondingCurve

**Purpose**  
- Creates and manages sub-tokens (AID) for each agent.  
- Enforces the 20% tax sink (5% burn, 5% to protocol DAO, 10% to the agent's treasury).  
- Maintains internal token reserves (the other 80%) for price discovery.

**Key Functions**  
- `initAgent(...)`: Sets up a new sub-token for an agent.  
- `buy(...)` & `sell(...)`: Standard bonding curve operations, applying the 20% sink.  
- `setCurveParams(...)`: Potentially adjust slope or fees if governance decides.

**File Location**  
- `contracts/economics/BondingCurve.sol`

---

### 2.3 AgentTerminal

**Purpose**  
- A minimal "treasury + logic" contract deployed per agent.  
- Receives the 10% agent share from BondingCurve trades.  
- Could handle investing, licensing proceeds, or collecting skill marketplace payments.

**Key Functions**  
- `initialize(...)`: Called once upon agent birth to bind references (agent ID, registry, etc.).  
- `executeBuyback(...)` (optional): The agent can call this to buy the NFT from the original owner if it has enough funds.  
- `deployDAO()`: If governance is optional, the agent can spawn a dedicated AgentDAO once threshold conditions are met.

**File Location**  
- `contracts/agent/AgentTerminal.sol`

---

### 2.4 AgentDAO

**Purpose**  
- Manages advanced governance for each agent's resources.  
- Uses the agent's sub-token (AID) for voting power.  
- Allocates treasury funds to proposals like marketing, IP deals, or cross-investments.

**Key Functions**  
- `propose(...)`, `vote(...)`, `execute(...)`: Standard DAO mechanics.  
- `modifyCurveParams(...)`: Possibly calls governance hooks in BondingCurve if delegated.  
- `approveIPLicenses(...)`: Could store an allowlist of IP license deals.

**File Location**  
- `contracts/agent/AgentDAO.sol`

---

## 3. System Design

### 3.1 Data Flows

1. **Agent Birth**  
   - User calls `birthAgent` in `ERC721AIRegistry`, depositing IAMAI (69k recommended).  
   - Registry routes 20% tax → 5% burn, 5% protocol DAO, 10% to the new agent's treasury.  
   - The BondingCurve mints 5% of sub-token supply directly to the NFT owner.  
   - The agent's `AgentTerminal` is deployed, referencing the new sub-token ID.

2. **Token Trades**  
   - Any buyer/seller calls `buy(...)` or `sell(...)` in BondingCurve with the agent's sub-token ID.  
   - 20% of each trade is taxed, with 5% burned, 5% to protocol, 10% to `AgentTerminal`.  
   - The rest adjusts the curve's reserve to set the sub-token price.

3. **Treasury & DAO**  
   - The agent's treasury grows from repeated BondingCurve trades or additional revenue streams (e.g., IP licensing).  
   - At a certain treasury threshold, the agent spawns `AgentDAO` to manage proposals, expansions, or the NFT buyback process.

### 3.2 Folder / File Structure

Below is a recommended approach:

```
iamai-protocol/
├── contracts/
│   ├── registry/
│   │   └── ERC721AIRegistry.sol
│   ├── economics/
│   │   └── BondingCurve.sol
│   ├── agent/
│   │   ├── AgentTerminal.sol
│   │   └── AgentDAO.sol
│   └── [misc/others... SkillMarketplace.sol, IPRegistry.sol, etc.]
├── docs/
│   ├── technical/
│   │   ├── architecture.md <-- You are here
│   │   └── devplan.md <-- Proposed dev plan
│   ├── whitepaper/
│   │   ├── sections/
│   │   └── ...
│   └── ...
├── scripts/
│   ├── deployRegistry.js
│   ├── deployBondingCurve.js
│   └── deployAgentSystem.js
└── test/
    ├── registry/
    ├── economics/
    ├── agent/
    └── ...
```

**Key Points**  
- Keep each contract in its logical folder.  
- Make specialized directories for test cases mirroring contract hierarchy.  
- `devplan.md` can reference these paths, plus detail environment configs, test approaches, etc.

### 3.3 Upgradability (Optional)

If you want to allow for evolution over time:

- Use OpenZeppelin `TransparentUpgradeableProxy` or `UUPSProxy` for each core contract.  
- Manage logic changes via the IAMAI Protocol DAO's admin keys.

### 3.4 TEE Integration Architecture

```
iamai-protocol/
├── contracts/
│   ├── tee/
│   │   ├── TEEVerification.sol
│   │   └── interfaces/
│   │       └── ITEEOperations.sol
│   └── ... existing folders ...
├── apps/
│   ├── tee-service/
│   │   ├── src/
│   │   │   ├── verification.ts
│   │   │   └── operations.ts
│   │   └── config/
│   │       └── tee-setup.ts
│   └── ... existing apps ...
```

**TEE Service Flow**
1. Agent Terminal requests operation
2. TEE environment executes in secure enclave
3. Result signed with Ed25519
4. On-chain verification of TEE signature
5. Operation execution with verified result

**Security Considerations**
- Implement proper nonce management
- Regular key rotation
- Attestation verification
- Secure enclave monitoring

## 3.5 Agent System Implementation

### Phase 1: Basic Terminal-DAO Setup
- Deploy Terminal with mock TEE verification
- Implement basic DAO with AID token voting
- Test basic proposal flow

### Phase 2: TEE Integration
- Select TEE provider (recommended: Azure Confidential Computing)
- Implement signature verification
- Add secure key management

### Phase 3: Treasury & Buyback
- Implement escrow for NFT buyback
- Add price negotiation mechanism
- Test full treasury management cycle

### Known Limitations & TODOs
1. **TEE Security**:
   - Need formal verification of signature scheme
   - Implement proper nonce management
   - Add key rotation mechanism

2. **DAO Operations**:
   - Add delegation support
   - Implement emergency pause mechanism
   - Add proposal templates

3. **Terminal Features**:
   - Add batch operation support
   - Implement proper error handling
   - Add event indexing for better tracking

## 4. Security Considerations

1. **Bonding Curve Manipulation**  
   - Protect buy/sell functions from re-entrancy.
   - Validate user input to prevent extreme or malicious trading that disrupts reserves.

2. **AgentTerminal**  
   - Single contract controlling an agent's funds—consider multi-sign or DAO gating for large withdrawals.  
   - Enforce strict roles and permission checks.

3. **DAO Governance**  
- Deploy timelocks on major proposals.
- Confirm safe external calls (no malicious contract addresses).
- Potential multi-sig or on-chain veto authority for major events.

4. **IP Rights**  
   - On-chain IP licensing must be carefully constructed to avoid real-world legal conflicts.
- Possibly mint "license NFTs" as proof of usage rights. 

5. **Upgrades**  
   - If using proxies, carefully design the upgrade path.
   - Strict timelock and DAO vote to pass major contract changes.

---
## 5. Next Steps (devplan.md)
After finalizing this architecture, create or refine a `devplan.md` covering:

1. **Implementation Milestones**

- Start with registry + bonding curve, proceed to agent treasury logic, then DAOs and optional modules.

2. **Testing Strategy**

- Unit tests in the corresponding folders.
- Integration tests for the full agent lifecycle.

3. **Deployment & Scripts**

- Provide scripts in scripts/ for local and testnet deployments.
- Document any environment variables or keys needed.

4. **Audits & Mainnet**

- Conduct internal or external audits once test coverage is thorough.
- Prepare for mainnet after addressing issues found in testnet deployments.

This structured approach guarantees that the IAMAI Protocol remains modular, secure, and scalable—enabling future expansions like skill marketplaces, advanced AI modules, or licensing frameworks to integrate seamlessly.

---

**End of IAMAI Protocol Architecture**

Keep this document updated as new features or governance changes arise, ensuring the community and developers have a clear blueprint for developing, testing, and deploying the next wave of AI-driven NFT agents.



