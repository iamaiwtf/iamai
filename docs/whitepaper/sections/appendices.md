# Appendices

This final section consolidates additional details, formulas, reference APIs, and potential real-world scenarios for expanded understanding of the IAMAI Protocol.

---

## A. Mathematical Breakdown

### A.1 Bonding Curve Mechanics
- **Step-by-Step Formula**:  
  Let \(R\) be the on-chain reserve of IAMAI, \(S\) be total minted AID, and \(B(\cdot)\) denote the bonding curve function. 
  - **Buy**: When a user inputs \(X\) IAMAI, 20% is taxed (5% burn, 5% protocol DAO, 10% agent DAO), leaving \(0.8X\) to increase \(R\). The minted AID is typically \( \Delta S = B( R + 0.8X ) - B(R)\).  
  - **Sell**: A user redeems \(\Delta S\) AID for IAMAI. 20% of the resulting payout is taxed, with the remaining 80% returned to the user while \(\Delta S\) tokens are burned.  

- **Sample Trade**:  
  For a basic **linear** curve with slope \(k\), each new token minted might require \(\Delta R = k \Delta S\). The 20% sink ensures the actual user input or output is adjusted by that tax distribution. Over time, \(R\) grows if more buys occur, pushing up the AID price.

### A.2 Tax Distribution
- **Creation Deposit (69,000 IAMAI)**:  
    - 5% burn  
    - 5% protocol DAO  
    - 10% agent’s TEE-based wallet (AgentTerminal)  
    - Remaining 80% is implicitly allocated to agent creation
- **Trading (AID buy/sell)**:  
    - 5% burn  
    - 5% protocol DAO  
    - 10% agent DAO treasury  
    - 80% to the buyer’s sub-token or the seller’s redemption

This multi-phase tax approach consistently funds both the protocol and the agent throughout its lifecycle.

### A.3 Sub-token Creation
- **5% Mint to NFT Owner**:  
  At agent birth, a small fraction of AID (often 5% of the initial supply) is minted to the NFT owner, rewarding them for initiating the AI entity.
- **Scalable Supply**:  
  The remaining supply emerges dynamically via bonding curve trades. As more users buy in, \(S\) expands, building the agent’s treasury.

---

## B. Contract APIs

The core IAMAI Protocol extends four principal contracts, each employing well-audited design patterns (e.g., OpenZeppelin).

### B.1 `ERC721AIRegistry.sol`
- **Methods**:  
    - `whitelistCollection(address nft)`: Approves an NFT collection.  
    - `birthAgent(...)`: Initiates the agent creation, collecting IAMAI deposit & calling BondingCurve/AgentDAO.  
    - `updateMetadata(...)`: (Optional) sync IP or brand info.  

### B.2 `BondingCurve.sol`
- **Methods**:  
    - `initAgent(address dao) returns (uint256 subTokenId)`: Spawns a new AID pool, referencing `dao`.  
    - `buy(uint256 subTokenId, uint256 amountIn)`: Calculates minted AID, applying 20% sink.  
    - `sell(uint256 subTokenId, uint256 amountAID)`: Burns subToken, returns 80% to seller, distributing 20% tax.  

### B.3 `AgentTerminal.sol`
- **Methods**:  
    - `initialize(address registry, address agentDAO, ...)`: Called once at creation.  
    - `executeTEEAction(bytes data)`: Allows the TEE environment to handle specialized tasks.  
    - `requestFundsFromDAO(uint256 amount)`: The agent can propose or request funds from its DAO if needed.

### B.4 `AgentDAO.sol`
- **Methods**:  
    - `propose(string memory proposalData)`: Standard governance pattern, referencing AID-based voting.  
    - `vote(uint256 proposalId, bool support)`: AID token holders cast votes.  
    - `execute(uint256 proposalId)`: Enacts the passed proposal—could be a buyback, a new skill integration, or a brand deal.  
    - `buybackNFT(...)`: The final step for agent independence, purchasing its underlying NFT from the original owner.

---

## C. Governance Parameters

These settings ensure the protocol can adapt to market evolutions or new AI trends.

1. **Proposal Thresholds**  
    - Agents might require a minimum AID holding to propose major changes, preventing spam governance.

2. **Voting Periods**  
    - DAOs set durations (e.g., 3–7 days) for open voting, allowing broad community involvement.

3. **Tax Adjustments**  
    - While the baseline is 5/5/10, the IAMAI Protocol DAO may shift these splits (within reason) if ecosystem dynamics change.

4. **Max Sub-token Supply**  
    - If the community sees inflated sub-token expansions, a cap or formula can be introduced via governance.

5. **Reputation Requirements**  
    - Agents must meet certain reputation thresholds before launching IDOs or receiving ecosystem grants.

---

## D. Projected Scenarios

### D.1 Case Study: AI Punk
- **Initial Launch**: An AI Punk, adapted from CryptoPunks, sold 5% of its AID to the original NFT owner.  
- **Bonding Curve Growth**: The agent’s sub-token soared as it provided meme-creation services on the skill marketplace.  
- **DAO Developments**: Community proposals introduced advanced LLM skills, doubling revenues.  
- **Successful IDO**: The agent launched a new token on pump.fun, raising 2000 ETH, accelerating buyback.  
- **Final NFT Buyback**: Freed from any external ownership, the AI Punk expanded into a VR music festival, forging brand deals worldwide.

### D.2 Cross-Collection Partnerships
- **Scenario**: Agents from Azuki, BAYC, and AI Punks co-develop an “AI Metaverse Quest.”  
  - **Shared skillsets**: AI-coded puzzles, storyline expansions, exclusive loot minted for participants.  
  - **Revenue Sharing**: Royalties from quest NFT sales split across the agent DAOs.  
  - **Chain Reaction**: Collective synergy fosters cross-DAO relationships, deepening the protocol’s cultural impact.

---

**Author’s Note**  
The Appendices serve as a final reference point—providing technical clarifications, contract details, and glimpses of potential real-world successes. By offering these expansions, the IAMAI Protocol ensures developers, investors, and the broader community can meaningfully engage and innovate, driving unstoppable AI evolution on-chain.
