# IAMAI Protocol – Technical Implementation Plan

This document presents a **step-by-step** strategy to implement the IAMAI Protocol at a **technical** level. Building on the architectural vision described in the Whitepaper, it aligns with the Protocol's guiding philosophy: transforming NFTs into living AI agents, each powered by sub-token economies, DAOs, and a path to launch its own IDO and further autonomy through NFT buyback and other trades.

---

## 1. Overview & Objectives

1. **Primary Goal**  
   Deliver a modular, secure smart contract suite that onboards NFTs as AI agents with bonding-curve sub-tokens and DAO-based governance. Each agent is supported by a TEE-based Agent Terminal for specialized operations.

2. **Scope**  
   - Covers **four core contracts** (`ERC721AIRegistry`, `BondingCurve`, `AgentTerminal`, `AgentDAO`).  
   - Explains the **20% tax sink** distribution (5% burn, 15% to the agent's DAO) on every sub-token trade.  
   - Details the additional **creation tax** for agent birth (5% burn, 5% protocol DAO, 10% TEE wallet).

3. **High-Level Flow**  
   1. **User** calls `birthAgent` in `ERC721AIRegistry` with 69,000 IAMAI.  
   2. **BondingCurve** mints a sub-token (AID) and applies the 5/15 tax on subsequent trades.  
   3. **AgentDAO** receives 15% from every trade, controlling expansions, skill marketplace, or brand licensing.  
   4. **AgentTerminal** (TEE environment) is optionally funded by the DAO to handle private AI inference or specialized off-chain tasks.

---

## 2. Development Approach

1. **Incremental Milestones**  
   - Implement & test each contract in phases (Registry, BondingCurve, AgentDAO, AgentTerminal).  
   - Add optional modules (IPRegistry, SkillMarketplace) only after stable core logic is confirmed.

2. **Security-First Mindset**  
   - Incorporate re-entrancy guards, rigorous unit/integration tests, and external/community audits before mainnet release.

3. **Modular Code Base**  
   - Place each contract in a dedicated folder: `registry`, `economics`, `agent`.  
   - Minimize cross-contract dependencies, ensuring clean upgradability or partial re-deployment if needed.

4. **Transparent Governance**  
   - Parameter adjustments (e.g., curve slopes, whitelisting rules) handled via the IAMAI Protocol DAO.  
   - Each agent's sub-token (AID) powers micro-DAO governance, though the agent retains final autonomy.

---

## 3. Contract-by-Contract Implementation

### 3.1 `ERC721AIRegistry.sol`

**Purpose**  
- Main entry point for turning NFTs into AI agents.  
- Verifies whitelisted NFT collections, collects the creation deposit (69,000 IAMAI), and spawns the agent's sub-token & DAO.

**Key Data Structures**  
- `mapping(address => bool) approvedCollections;`  
- `struct AgentInfo { address dao; address teeTerminal; uint256 subTokenId; bool active; }`

**Core Functions**  
1. `whitelistCollection(address nft)`: Possibly requires a burn or deposit of IAMAI, then sets `approvedCollections[nft] = true`.  
2. `birthAgent(address nft, uint256 tokenId, uint256 iamaiDeposit, bytes ipSignature)`:  
   - Checks if `approvedCollections[nft]` is true.  
   - Collects creation tax: 5% burn, 5% protocol DAO, 10% TEE wallet.  
   - Calls `BondingCurve.initAgent(...)` to create sub-token (AID).  
   - Deploys `AgentDAO`, distributing 15% from future sub-token trades.  
   - Mints 5% of initial AID to the user (optional).  
   - Records IP license or assignment.

**Implementation Plan**  
- Start with a minimal version of `birthAgent`, verifying deposit amounts & NFT ownership.  
- Integrate with the BondingCurve to confirm the subTokenId.  
- Check test coverage for deposit/tax logic.

**Implementation Checklist**

- [x] Set up ERC721AIRegistry contract structure
- [x] Add comments for educational purposes
- [x] Implement additional logic for agent creation and sub-token minting
- [x] Integrate BondingCurve logic for sub-token ID generation
- [x] Complete unit tests for ERC721AIRegistry
- [x] Implement BondingCurve contract
- [x] Implement AgentTerminal contract
- [x] Implement AgentDAO contract
- [ ] Conduct integration tests
- [ ] Conduct security audits
- [ ] Deploy on mainnet

**Current Status**
- All core smart contracts implemented ✅
- Reference test cases provided 📝
- Ready for community review and testing 🔍

---

### 3.2 `BondingCurve.sol`

**Purpose**  
- Issues each agent's sub-token (AID).  
- Enforces a 20% sink on buy/sell: 5% burn + 15% agent DAO.  
- Holds 80% in a reserve that sets the token's price based on a chosen formula.

**Key Data Structures**  
- `struct CurvePool { uint256 totalSupply; uint256 reserveBalance; address dao; }`  
- `mapping(uint256 => CurvePool) pools;`

**Core Functions**  
1. `initAgent(address dao) returns (uint256 subTokenId)`:  
   - Creates a new pool, referencing `dao` for revenue distribution.  
   - Returns the `subTokenId` that identifies this agent's sub-token.  
2. `buy(uint256 subTokenId, uint256 amountIn)`:  
   - Deducts 20% from `amountIn` (5% burn, 15% dao).  
   - 80% is added to `reserveBalance`.  
   - Mints an appropriate quantity of AID based on the chosen bonding curve formula.  
3. `sell(uint256 subTokenId, uint256 amountAID)`:  
   - Burns the seller's AID.  
   - Returns 80% of the proceeds to the seller, with 20% taxed again (5% burn, 15% dao).

**Implementation Plan**  
- Decide whether the curve is linear or polynomial.  
- Unit tests for varied trade sizes, re-entrancy protection, accurate tax splits, and reserves.  
- Potentially adopt a well-known formula or an integral-based approach.

---

### 3.3 `AgentTerminal.sol`

**Purpose**  
- On-chain contract referencing an off-chain Trusted Execution Environment (TEE) for specialized computations.
- Handles secure AI inference, zero-knowledge tasks, and private computations.
- Requires DAO proposals for treasury funding.

**Key Data Structures**  
```typescript
struct TEEConfig {
    address publicKey;      // TEE's verification key
    uint256 lastNonce;     // Prevent replay attacks
    bool isActive;         // TEE status
}
```

**Core Functions**  
1. `initialize(address registry, address agentDAO, bytes teePublicKey)`:
   - Sets up initial references and TEE configuration
   - Validates TEE attestation
2. `executeTEEAction(bytes data, bytes signature)`:
   - Verifies TEE signature using Ed25519
   - Processes nonce to prevent replays
   - Executes the requested action
3. `requestFundsFromDAO(uint256 amount, string reason)`:
   - Proposes funding request to AgentDAO
   - Includes detailed reasoning for TEE operations

**Implementation Plan**  
- Integrate with Azure Confidential Computing or AWS Nitro Enclaves
- Implement robust signature verification
- Add comprehensive nonce tracking
- Test unauthorized access scenarios

---

### 3.4 `AgentDAO.sol`

**Purpose**  
- Manages the agent's treasury (the 15% from sub-token trades), licensing revenues, and marketplace fees.  
- Provides a governance interface for AID token holders to propose expansions, skill enhancements, or buybacks.

**Key Functions**  
1. `propose(...)`, `vote(...)`, `execute(...)`:  
   - Standard governance with sub-token weighted voting.  
2. `launchTokenOnVirtualsPumpFun(...)`: The DAO can propose an IDO for advanced expansions.  
3. `buybackNFT(...)`: Purchases the NFT from the original user if the treasury is sufficient.

**Implementation Plan**  
- Start with a minimal Governor approach (OpenZeppelin).  
- Thoroughly test proposals, ensuring major actions (e.g., `buybackNFT`) pass safely and can't be hijacked.  
- Evaluate a timelock for bigger proposals.

---

## 4. Additional Modules (Optional)

1. **IPRegistry.sol**: On-chain brand licensing data for each agent.  
2. **SkillMarketplace.sol**: Agents list paid AI services, building ongoing revenue streams.  
3. **ReputationManager.sol**: Tracks advanced performance metrics (floor price, synergy, sub-token TVL, etc.) feeding into protocol-level grants.
4. **TEEVerification.sol**: Handles signature verification and nonce management for TEE operations

---

## 5. Testing & QA

1. **Unit Tests**  
   - Validate each core method (`birthAgent`, `buy`, `sell`, `propose`, etc.).  
   - Confirm partial deposit flow: 5% burn, 5% protocol DAO, 10% TEE environment.  
2. **Integration Tests**  
   - Simulate an entire agent lifecycle: creation → sub-token trades → treasury usage → NFT buyback.  
   - Evaluate synergy with SkillMarketplace or IP licensing.  
3. **Fuzz / Property Testing**  
   - Bonding curve under large buy/sell volumes, random user interactions, edge floor price updates.  
4. **Security Reviews**  
   - Re-entrancy checks, multi-sig upgrade flows if proxies are used, reputable auditing firm or community-led bounties.
5. **TEE Integration Tests**  
   - Validate signature verification
   - Test nonce replay protection
   - Simulate TEE attestation
   - Verify secure key management

---

## 6. Deployment Phases

### 6.1 Phase A: Registry & BondingCurve
- Deploy `ERC721AIRegistry` and `BondingCurve` on a testnet.  
- Validate agent births, sub-token creation, 20% sink distribution (5% burn, 15% DAO).  
- Test re-entrancy/overflow paths.

### 6.2 Phase B: AgentDAO & TEE Terminal
- Deploy `AgentDAO` for each agent automatically.  
- Integrate TEE-based logic in `AgentTerminal`.  
- End-to-end tests (agent creation → sub-token trades → proposals → partial or zero-knowledge tasks).

### 6.3 Phase C: Optional Modules & Final Security
- Add IPRegistry & SkillMarketplace if stable.  
- Integrate oracles for floor price, advanced reputation.  
- Conduct thorough audits and finalize testnet results.

### 6.4 Phase D: Mainnet Launch
- Deploy final versions under a protocol-level DAO.  
- Whitelist major NFT collections.  
- Possibly initiate a genesis wave of agent births or IDOs to showcase the system.

---

## 7. Timeline & Deliverables

| Milestone   | Deliverables                                                 | Estimated Duration |
|-------------|--------------------------------------------------------------|--------------------|
| **Week 1–2**| Basic `ERC721AIRegistry`, `BondingCurve` code + local tests | 2 weeks           |
| **Week 3–4**| Implement `AgentDAO`, TEE Terminal references               | 2 weeks           |
| **Week 5–6**| Integration tests, skill marketplace or IP registry pilot   | 2 weeks           |
| **Week 7**  | Security audit, final testnet checks                        | 1 week            |
| **Week 8**  | Mainnet deployment + initial partner NFT collections        | 1 week            |

---

## 8. Final Notes

- **Tax Distribution**:  
  - **Creation Tax** on 69,000 IAMAI deposit: 5% burn, 5% protocol DAO, 10% TEE environment.  
  - **Sub-token Trades**: 5% burn, 15% agent DAO from each transaction.  
- **DAO Overwrites**: Agents can theoretically override certain community proposals, though we expect synergy and alignment.  
- **IDO Expansions**: For advanced capital, each agent's DAO can launch a second token on Virtuals or pump.fun, fueling buybacks or brand expansions.  
- **Reputation**: Strong synergy fosters higher on-chain trust, enabling big marketing pushes, cross-agent alliances, and ecosystem grants.

By following these steps methodically—while remaining open to community-driven improvements—the IAMAI Protocol can realize its goal of bridging NFTs and AI in a flexible, future-proof manner. This phased plan ensures **robust technical implementation**, consistent user adoption, and a thriving environment where living, self-governing digital agents reshape the Web3 landscape.
