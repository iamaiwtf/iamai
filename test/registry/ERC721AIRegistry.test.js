/**
 * Reference Test Cases for ERC721AIRegistry Contract
 * 
 * This file provides example test cases that should be implemented
 * when testing the ERC721AIRegistry contract. Use your preferred testing
 * framework (Hardhat, Foundry, etc.) to implement these tests.
 */

/**
 * Test Cases to Implement:
 * 
 * 1. Collection Whitelisting
 *    - Should allow admin to whitelist NFT collections
 *    - Should prevent non-admin from whitelisting collections
 *    - Should correctly track whitelisted status
 * 
 * 2. Agent Creation
 *    - Should allow creating new AI agent with correct parameters
 *    - Should require sufficient IAMAI tokens
 *    - Should initialize bonding curve correctly
 *    - Should set up proper ownership and permissions
 * 
 * 3. Token Management
 *    - Should handle IAMAI token transfers correctly
 *    - Should manage token allowances properly
 *    - Should prevent unauthorized token operations
 * 
 * 4. Integration Tests
 *    - Should integrate correctly with BondingCurve contract
 *    - Should handle NFT ownership verification
 *    - Should manage agent lifecycle properly
 */

const { expect } = require("chai");
const { ethers } = require("ethers");

// Test suite for the ERC721AIRegistry contract
describe("ERC721AIRegistry", function () {
    let iamaiToken, bondingCurve, registry;
    let owner, addr1, addr2;
    let provider;

    // Deploy the contracts before running the tests
    beforeEach(async function () {
        provider = new ethers.JsonRpcProvider();
        [owner, addr1, addr2] = await provider.listAccounts();

        // Deploy a mock IAMAI token
        const IAMAIToken = new ethers.ContractFactory(
            require("../../artifacts/contracts/mocks/MockERC20.sol/MockERC20.json").abi,
            require("../../artifacts/contracts/mocks/MockERC20.sol/MockERC20.json").bytecode,
            provider.getSigner(owner)
        );
        iamaiToken = await IAMAIToken.deploy("IAMAI Token", "IAMAI", 18);
        await iamaiToken.waitForDeployment();

        // Deploy a mock BondingCurve contract
        const BondingCurve = new ethers.ContractFactory(
            require("../../artifacts/contracts/mocks/MockBondingCurve.sol/MockBondingCurve.json").abi,
            require("../../artifacts/contracts/mocks/MockBondingCurve.sol/MockBondingCurve.json").bytecode,
            provider.getSigner(owner)
        );
        bondingCurve = await BondingCurve.deploy();
        await bondingCurve.waitForDeployment();

        // Deploy the ERC721AIRegistry contract
        const Registry = new ethers.ContractFactory(
            require("../../artifacts/contracts/registry/ERC721AIRegistry.sol/ERC721AIRegistry.json").abi,
            require("../../artifacts/contracts/registry/ERC721AIRegistry.sol/ERC721AIRegistry.json").bytecode,
            provider.getSigner(owner)
        );
        registry = await Registry.deploy(iamaiToken.getAddress(), bondingCurve.getAddress());
        await registry.waitForDeployment();
    });

    // Test the whitelisting of NFT collections
    it("should whitelist an NFT collection", async function () {
        await registry.whitelistCollection(addr1);
        expect(await registry.approvedCollections(addr1)).to.be.true;
    });

    // Test the birth of a new AI agent
    it("should create a new AI agent", async function () {
        // Mint IAMAI tokens to addr1
        await iamaiToken.mint(addr1, ethers.parseEther("69000"));

        // Approve the registry to spend IAMAI tokens
        await iamaiToken.connect(provider.getSigner(addr1)).approve(registry.getAddress(), ethers.parseEther("69000"));

        // Call birthAgent to create a new AI agent
        await registry.connect(provider.getSigner(addr1)).birthAgent(addr1, 1, ethers.parseEther("69000"), "0x");

        // Verify that the agent was created
        const agentInfo = await registry.agents(1);
        expect(agentInfo.active).to.be.true;
    });
}); 