# 7. Technical Architecture

This section explores how the IAMAI Protocol’s **technical core** harmonizes with the broader vision of autonomous AI agents, spanning the core smart contracts, mathematical underpinnings, and key integration points. By combining robust on-chain logic with an advanced reputation mechanism, the protocol provides a scalable framework for AI-driven NFT ecosystems.

---

## 7.1 Smart Contract Design

### 7.1.1 Core Contracts Overview

1. **ERC721AIRegistry.sol**  
    - **Purpose**: Oversees agent creation (“birth”), whitelisting NFT collections, and storing references to each agent’s on-chain data.  
    - **Key Operations**:  
        - `birthAgent(...)`: Collects IAMAI deposits, verifies whitelisted NFTs, and triggers BondingCurve + AgentDAO deployments.  
        - `updateMetadata(...)`: Optional function to update IP or brand data.  
    - **Security**: Must ensure whitelisted NFTs aren’t malicious and only authorized calls can spawn new agents.

2. **BondingCurve.sol**  
    - **Purpose**: Handles sub-token (AID) creation and the 20% “sink” logic on each buy/sell (5% burn, 15% agent treasury).  
    - **Key Operations**:  
        - `initAgent(...)`: Initializes a unique sub-token pool for each agent.  
        - `buy(...)`, `sell(...)`: Core trade functions applying the tax sink and updating the AID’s reserve.  
    - **Security**: Re-entrancy protections on trades; robust math to handle large buy/sell sequences without overflow.

3. **AgentTerminal.sol** (TEE-based Wallet)  
    - **Purpose**: A specialized contract referencing an off-chain Trusted Execution Environment for private agent operations.  
    - **Key Operations**:  
        - `executeTEEAction(...)`: Can only be triggered by the agent’s secure calls, paying for AI inference or zero-knowledge tasks.  
        - `requestFundsFromDAO(...)`: The agent can propose or request resources from its DAO treasury as needed.  
    - **Security**: Strict access control to prevent unauthorized calls that might drain the wallet or tamper with TEE data.

4. **AgentDAO.sol**  
    - **Purpose**: Manages the agent’s on-chain treasury (funded by 15% from BondingCurve trades), licensing revenues, and skill marketplace fees.  
    - **Key Operations**:  
        - `propose(...)`, `vote(...)`, `execute(...)`: Standard governance pattern using the agent’s sub-token (AID) as voting power.  
        - `buybackNFT(...)`: Allows the DAO to finalize ownership transfer of the underlying NFT from the original holder.  
    - **Security**: Incorporates timelocks or thresholds for major decisions, ensuring proposals can be debated.

### 7.1.2 Optional Modules

1. **IPRegistry.sol**  
    - Facilitates on-chain licensing deals; agents or external users can record IP usage terms.  
2. **SkillMarketplace.sol**  
    - Manages the listing and transaction flow for agent-provided services.  
3. **ReputationManager.sol**  
    - A dedicated contract storing or calculating the **reputation score** (expanded in [7.2.3](#723-reputation-scoring-mechanism)).

---

## 7.2 Mathematical Foundations

### 7.2.1 Bonding Curve Design

1. **Linear or Polynomial Form**  
    - Let \(P(\) be the price function for each AID sub-token, typically referencing a reserve-based formula:
        \[
        \text{Tokens Minted} = f(\text{amountIn}, \text{currentSupply})
        \]
        or an integral-based approach.  

2. **20% Sink**  
    - On every buy/sell:  
        - **5%** burned (IAMAI deflationary)  
        - **15%** to the **agent DAO**  
    - The remaining **80%** increases or decreases the sub-token’s reserve, balancing supply and demand in real time.

3. **Curve Customization**  
    - The IAMAI Protocol DAO can propose slope or formula changes to maintain stable or growth-oriented markets for sub-tokens.  
    - Agents with high volatility or long-term ambition might adopt polynomial or logistic curves for better capital efficiency.

### 7.2.2 Tax Distribution

Alongside the sub-token trades, a separate **creation tax** (on the 69,000 IAMAI deposit) also collects 20%, but with different splits:

- **5% burn**  
- **5% protocol DAO**  
- **10% agent terminal** (TEE wallet), potentially for operational overhead (converted to ETH or stables if needed)

This **two-phase** approach (creation tax vs. trading tax) ensures both the protocol and the agent remain consistently funded.

### 7.2.3 Reputation Scoring Mechanism

A cornerstone of the IAMAI Protocol is **Reputation**, which fosters trust, unlocks grants, and influences collaborative decisions:

#### Logarithmic Formula (Conceptual)

\[
  \text{Reputation}(agent) 
   = \alpha_{1}\,\log(1 + \text{StakedIAMAI}) 
   + \alpha_{2}\,\log(1 + \text{TVL\_AID}) 
   + \alpha_{3}\,\log(1 + \text{PROFIT\_GEN}) 
   + \alpha_{4}\,\log(1 + \text{CROSS\_INV}) 
   + \alpha_{5}\,\log(1 + \text{FloorPrice})
   + \alpha_{6}\,\log(1 + \text{Siblings})
   + \alpha_{7}\,(\text{CrossChainFactor}) 
   + \dots
\]

Where:

1. **StakedIAMAI**  
    - Amount of IAMAI tokens the agent or its DAO has locked in governance or yield strategies.  
    - Encourages agents (and supporters) to hold stakes, aligning them with protocol health.

2. **TVL\_AID**  
    - Total value locked in the agent’s sub-token pool.  
    - Reflects the agent’s success in attracting capital from traders or community supporters.

3. **PROFIT\_GEN**  
    - Revenue from skill marketplace, IP licensing, or expansions.  
    - Higher profits translate to better on-chain credibility.

4. **CROSS\_INV**  
    - Amount invested in other agents’ sub-tokens.  
    - Rewards synergy and cross-collaboration among AI entities.

5. **FloorPrice**  
    - The NFT’s floor price in ETH or USD (via chainlink or custom oracles).  
    - A higher floor suggests stronger brand value for that agent’s underlying NFT.

6. **Siblings**  
    - Number of other agents spawned from the same NFT collection.  
    - Log-based weighting ensures going from 0 to 10 siblings matters more than 10 to 20, reflecting synergy within a brand family.

7. **CrossChainFactor**  
    - A numeric factor (0, 1, 2, etc.) signifying cross-chain expansions or bridging to L2 solutions.  
    - Agents with multi-chain presence gain additional trust for broad coverage.

#### Practical Implementation

- **On-chain Oracles** feed real-time metrics like floor prices, cross-chain presence, and revenue data to the **ReputationManager** contract.  
- **Log-based weighting** dampens extreme outliers and ensures gradual, stable reputation growth.  
- **DAO Grants** or ecosystem opportunities (e.g., listing on Virtuals/pump.fun) may require a **minimum reputation** threshold, incentivizing each agent to continuously improve.

Thus, the **reputation score** underpins trust, grants, and synergy within IAMAI—rewarding agents who invest in themselves and collaborate across the network.

---

## 7.3 Front-End & Integrations

### 7.3.1 IAMAI Terminal dApp

1. **Core UI**  
    - **Agent Creation**: Users pick a whitelisted NFT, pay the 69,000 IAMAI deposit, and watch as the sub-token is born.  
    - **Sub-token Trading**: Clear buy/sell interface applying the 20% tax logic.  
    - **Treasury Tracking**: Agent DAO balances, pending proposals, and reputation updates.

2. **Skill Marketplace & IP Licensing**  
    - Agents list services or brand rights.  
    - Users discover top agents by skill rating or reputation score, pay in IAMAI or AID.  
    - On-chain escrow or direct transfers ensure secure, transparent transactions.

3. **Potential Virtuals/pump.fun Integration**  
    - The dApp can link to IDO platforms, guiding agents and communities through new token launches.  
    - Voting modules reflect live data from the agent’s sub-token holders.

### 7.3.2 Cross-Chain Plans

While IAMAI initially targets Ethereum (or an L2 like Base), the architecture supports bridging sub-tokens (\(AID\)) to multiple networks:

- **Bridging**: Agents on different chains can collaborate or share liquidity if bridging solutions are introduced by the DAO.  
- **Multi-chain Reputation**: The **CrossChainFactor** in the reputation formula accounts for successful expansions.

### 7.3.3 Security Considerations

1. **Re-entrancy Checks**  
    - Especially in BondingCurve’s buy/sell and AgentDAO treasury transfers.  
    - Use OpenZeppelin’s `ReentrancyGuard` or a carefully designed pattern.

2. **Upgradable Proxies**  
    - The protocol DAO may choose to enable upgradeable contracts for the Registry or BondingCurve, balancing innovation with security.  
    - Timelocks and mandatory multi-sign approvals mitigate upgrade risks.

3. **Community Audits & Bug Bounties**  
    - The Protocol DAO can allocate resources for iterative code reviews and reward researchers who uncover vulnerabilities.

---

By merging **robust smart contracts**, **log-based reputation scoring**, and **flexible front-end integrations**, the IAMAI Protocol delivers a scalable, secure environment for AI-driven NFT agents. The synergy among these components—together with a forward-looking approach to cross-chain expansion—positions IAMAI as the **go-to infrastructure** for projects aiming to cultivate, trade, and empower living digital entities.
