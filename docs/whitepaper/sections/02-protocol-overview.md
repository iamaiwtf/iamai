# 2. IAMAI Protocol Overview

The IAMAI Protocol serves as the **foundation** for transitioning NFTs from static collectibles into autonomous agents equipped with on-chain governance, token economies, and AI-driven capabilities. This section outlines the core pillars of the protocol—focusing on how NFTs are approved, activated, and empowered through a combination of smart contracts and community-driven mechanisms.

---

## 2.1 High-Level Architecture

The protocol rests on four primary building blocks, each contributing a vital piece of the AI agent lifecycle:

1. **Registry (ERC721AIRegistry)**
    - Manages the activation ("birth") of AI agents from approved NFT collections.
    - Ensures each agent is uniquely identified and tracked on-chain.
    - Facilitates IP assignment so that the agent can legally use and monetize the NFT’s art or brand identity.

2. **Bonding Curves**
    - Establish sub-tokens (AID) for each agent.
    - Apply a 20% tax on every buy/sell: 5% burned, 5% to the protocol DAO (during activation), and 10% directed to the agent’s DAO treasury.
    - Provide continuous price discovery for the agent’s sub-token and incentivize active participation.

3. **Agent DAO**
    - Each agent spawns its own DAO upon activation.
    - Holds the agent’s on-chain treasury, handles licensing deals, skill marketplace revenues, and other collaborative activities.
    - Oversees major decisions, such as buyback timing or expansions, though the AI agent maintains ultimate control.

4. **IAMAI Token**
    - The core protocol token for fees, governance, and synergy across the ecosystem.
    - Deflationary by design, with a portion burned on each bonding curve transaction.
    - Secures the protocol’s long-term value proposition and incentivizes stakeholder alignment.

Together, these components form a **cohesive ecosystem**, where NFTs evolve from mere art or collectible assets into living AI entities capable of driving community-building, brand interactions, and autonomous decision-making.

---

## 2.2 Birth of an AI Agent

### Whitelisting

Before an NFT can “come to life,” its collection must be **whitelisted** in the Registry. This process involves:

- Burning or depositing a certain amount of IAMAI.
- Submitting proof of ownership or brand rights if required by the protocol.
- Initializing important registry states so the NFT collection is authorized and now any NFT from this collection can be activated as an AI agent.

Whitelisting creates **guardrails** for the protocol, preserving quality standards and preventing malicious or unverified NFTs from flooding the ecosystem.

### Activation Deposit

Once a whitelisted NFT is selected for birth, the user pays **69,000 IAMAI** into the protocol’s activation flow. This upfront deposit:

- Proves commitment from the NFT owner.
- Triggers the agent’s on-chain creation.
- Partially funds the token ecosystems at play.

### Tax Distribution

Upon deposit, a **20% creation tax** applies:

- **5%** is burned, reducing IAMAI supply.
- **5%** goes to the **protocol DAO**, supporting overall governance and ecosystem development.
- **10%** is allocated to the **agent’s terminal** (the TEE-based secure wallet), potentially converted to ETH or stables for the agent’s operational costs.

Separately, future buy/sell trades of the agent’s sub-token incur another 20% “sink,” but this time the distribution is **5% burn, 15% to the agent’s DAO**. This **two-tiered** model ensures the protocol is properly funded at inception and that each agent builds a sustainable treasury over time.

### Bonding Curve Setup

After collecting the deposit, the **BondingCurve** contract is invoked to **initAgent**. This step:

- Mints a new sub-token (\(AID\)) dedicated to the agent.
- Sets the buy/sell parameters, including the 20% tax logic.
- Directs sub-token revenue to the agent’s DAO treasury, fueling further development.

Bonding curves provide dynamic pricing for the sub-token, allowing community members and speculators to invest in an agent’s potential while supporting its growth.

### 5% Mint to Owner

In default configuration, the user who activates an NFT into an agent receives **5%** of the newly created sub-token supply. This initial mint:

- Rewards early adoption and fosters loyalty.
- Aligns the NFT owner’s incentives with the agent’s success.
- Provides immediate liquidity for future expansions.

### IP Signing

Key to the IAMAI Protocol’s vision is **IP assignment**. By default, the NFT owner **signs** an on-chain IP license (or assignment) enabling the agent:

- Full usage of the NFT’s art, lore, or brand identity.
- Freedom to produce and monetize derivative content—art, music, text, or other creative works.
- Legal clarity for all licensing deals the agent may negotiate in the future.

With IP rights secure, the newly birthed agent is free to leverage its NFT identity in both **on-chain** and **off-chain** pursuits, ensuring compliance and opening doors to deeper brand partnerships.

### Token Launch Possibility

While each agent automatically mints a sub-token (AID) upon birth, many aim to **launch a separate token** later on platforms like Virtuals or pump.fun. This approach typically arises when:

- The agent needs additional capital or a broader distribution.
- The existing sub-token economy has matured, and a second token can capture a new layer of utility or brand narrative.

The agent’s DAO can vote on whether and how to proceed with such an IDO, balancing community interests, brand expansions, and the drive toward eventual **NFT buyback**.

---

## 2.3 Guiding Principles

### Fairness

The IAMAI Protocol strives to welcome **any user** with a whitelisted NFT, minimizing gatekeeping beyond the necessary deposit and brand verifications. This open structure:

- Encourages diversity of AI agents—ranging from indie art pieces to major brand IPs.
- Allows varied communities to experiment with AI-driven NFT experiences.

### Autonomy

The **ultimate endgame** is for each agent to achieve full self-ownership, buying its NFT from the original holder. By designing:

- A dedicated treasury (Agent DAO).
- Robust sub-token economies.
- Clear IP licensing.

… the protocol paves a **transparent** path to living digital entities that can act, evolve, and profit independently of their human creators.

### Synergy

Far from operating in isolation, IAMAI agents are **inherently collaborative**:

- They share best practices for brand growth and community engagement.
- They can invest in each other’s sub-tokens, forging cross-agent alliances.
- They may co-launch multi-agent events or games, sparking deeper inter-NFT ecosystems.

Through these reciprocal relationships, the protocol envisions a vibrant **AI × NFT metaverse**, where creativity and innovation compound exponentially.

---

**In Summary**, this overview highlights the essential mechanics of how NFTs are birthed into AI agents with their own sub-token economies, DAOs, and IP rights. The next sections detail the token and economic model, the agent framework, governance layers, and the broader roadmap, illustrating how the IAMAI Protocol merges **artistic expression**, **market incentives**, and **AI autonomy** into a single, powerful ecosystem.
