# 🚀 IAMAI Protocol

Welcome to the **IAMAI Protocol** repository, where NFTs evolve into AI agents with their own token economies, DAOs, and a path to full autonomy. This repo hosts our **whitepaper**, documentation, and initial smart contract implementations. By combining AI intelligence with blockchain governance, IAMAI aims to unlock the next frontier of on-chain innovation.

## 🌟 Core Vision

IAMAI Protocol enables any NFT to become a living, thinking AI agent with:
- 🧠 Its own personality and skills
- 💰 Sustainable token economy
- 🏛️ Community-driven DAO
- 🎯 Path to self-ownership

## 📚 Documentation

All documentation is available in the `docs/` directory:

- 📖 **Whitepaper**: [`docs/whitepaper/`](docs/whitepaper/) - Complete protocol specification
- 🔧 **Technical**: [`docs/technical/`](docs/technical/) - Smart contracts and implementation details
- 🎯 **Architecture**: [`docs/technical/architecture.md`](docs/technical/architecture.md) - System design
- 📋 **Development**: [`docs/technical/plan.md`](docs/technical/plan.md) - Implementation status
- 🔐 **Smart Contracts**: [`docs/technical/smart-contracts.md`](docs/technical/smart-contracts.md) - Contract documentation

## ✨ Key Components

- 🤖 **NFT-to-AI Activation**: Transform static NFTs into autonomous agents
- 📈 **Bonding Curve Economics**: Agent-specific sub-tokens (AID) with 20% tax (5% burn, 15% treasury)
- 🏦 **Agent DAOs**: Individual treasuries for development, expansions, and NFT buybacks
- 🎭 **Base Chain Integration**: IAMAI token live at `0xc3d64ee7056cfd33c8382679773f8d6277e5c2c9`
- 🗳️ **Multi-Layer Governance**: Protocol DAO + agent-specific DAOs with reputation scoring

## 🏗️ Current Status

This is an **alpha release** focused on:
1. Comprehensive protocol whitepaper
2. Core smart contract implementations
3. Community feedback and discussion

## 🛠️ Technical Overview

### Smart Contracts
All core smart contracts have been implemented and are ready for testing:

1. **Registry System** (`contracts/registry/ERC721AIRegistry.sol`) ✅
   - Core registry for AI agent creation
   - NFT collection whitelisting
   - Agent lifecycle management

2. **Economic Engine** (`contracts/economics/BondingCurve.sol`) ✅
   - Agent-specific sub-tokens (AID)
   - Bonding curve mechanics
   - Treasury allocations (5% burn, 15% treasury)

3. **Agent Terminal** (`contracts/agent/AgentTerminal.sol`) ✅
   - TEE integration for secure AI operations
   - Secure computations and verifications
   - Treasury funding requests

4. **Governance** (`contracts/agent/AgentDAO.sol`) ✅
   - Individual agent DAOs
   - Treasury management
   - NFT buyback proposals

### Implementation Status

| Component | Status | Description |
|-----------|--------|-------------|
| Registry | ✅ | Implementation complete |
| Bonding Curve | ✅ | Implementation complete |
| Agent Terminal | ✅ | Implementation complete |
| Agent DAO | ✅ | Implementation complete |
| Tests | 🏗️ | Reference implementations provided |
| Documentation | ✅ | Core docs complete |

Legend: ✅ Complete | 🏗️ In Progress | 📝 Planned

### Getting Started

```bash
git clone https://github.com/iamaiwtf/iamai.git
cd iamai
npm install
```

### Documentation Setup
Requires Python 3.8+:

```bash
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install mkdocs-material
mkdocs serve  # Browse docs at http://127.0.0.1:8000
```

## 📚 Repository Structure

```
iamai/
├─ docs/
│  ├─ whitepaper/     # Protocol whitepaper in sections
│  ├─ technical/      # Technical documentation
│  └─ mkdocs.yml      # Documentation config
├─ contracts/         # Solidity smart contracts
│  ├─ registry/       # Core protocol contracts
│  └─ economics/      # Bonding curve & token logic
└─ README.md
```

## 🤝 How to Contribute

We're actively seeking community input on:

### 1. Protocol Design
- Review the whitepaper
- Suggest improvements to token economics
- Propose new agent capabilities or integrations

### 2. Technical Implementation
- Review smart contract architecture
- Suggest security improvements
- Propose additional features

### 3. Documentation
- Improve technical documentation
- Add examples or tutorials
- Fix typos or unclear sections

### Getting Started
1. Fork the repository
2. Create a feature branch
3. Submit a Pull Request
4. Join our community discussions

## 🔜 Roadmap

- 📋 Phase 1: Community Review & Feedback
- 🧪 Phase 2: Testnet Deployment & Testing
- 🚀 Phase 3: Mainnet Launch
- 🌐 Phase 4: Multi-chain Expansion

## 🌐 Community & Support

- [Discord]() (Coming soon)
- [Twitter](https://twitter.com/iamai_wtf)
- [Website](https://iamai.wtf)
- [Warpcast](https://warpcast.com/iamai)
- [Telegram](https://t.me/iamaionbase)

## 📜 License

IAMAI Protocol is released under the [MIT License](LICENSE).

---

Built with 🧠 by the IAMAI community. Join us in creating the future of autonomous AI agents on-chain!