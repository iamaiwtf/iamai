/**
 * Reference Test Cases for BondingCurve Contract
 * 
 * This file provides example test cases that should be implemented
 * when testing the BondingCurve contract. Use your preferred testing
 * framework (Hardhat, Foundry, etc.) to implement these tests.
 */

/**
 * Test Cases to Implement:
 * 
 * 1. Agent Initialization
 *    - Should initialize a new agent with correct DAO address
 *    - Should set initial totalSupply and reserveBalance to 0
 * 
 * 2. Token Purchase
 *    - Should allow buying tokens on the bonding curve
 *    - Should update totalSupply and reserveBalance correctly
 *    - Should transfer correct amount of tokens
 * 
 * 3. Token Sale
 *    - Should allow selling tokens on the bonding curve
 *    - Should update totalSupply and reserveBalance correctly
 *    - Should transfer correct amount of tokens back
 * 
 * 4. Edge Cases
 *    - Should handle zero amount purchases/sales
 *    - Should prevent unauthorized access to admin functions
 *    - Should handle multiple buys/sells correctly
 */

const { expect } = require("chai");
const { ethers } = require("ethers");

// Test suite for the BondingCurve contract
describe("BondingCurve", function () {
    let bondingCurve;
    let owner, addr1;
    let provider;

    // Deploy the contract before running the tests
    beforeEach(async function () {
        provider = new ethers.JsonRpcProvider();
        [owner, addr1] = await provider.listAccounts();

        // Deploy the BondingCurve contract
        const BondingCurve = new ethers.ContractFactory(
            require("../../artifacts/contracts/economics/BondingCurve.sol/BondingCurve.json").abi,
            require("../../artifacts/contracts/economics/BondingCurve.sol/BondingCurve.json").bytecode,
            provider.getSigner(owner)
        );
        bondingCurve = await BondingCurve.deploy();
        await bondingCurve.waitForDeployment();
    });

    // Test the initialization of a new agent
    it("should initialize a new agent", async function () {
        const daoAddress = addr1;
        const subTokenId = await bondingCurve.initAgent(daoAddress);

        // Verify that the agent was initialized
        const pool = await bondingCurve.pools(subTokenId);
        expect(pool.dao).to.equal(daoAddress);
        expect(pool.totalSupply).to.equal(0n);
        expect(pool.reserveBalance).to.equal(0n);
    });

    // Test buying tokens on the bonding curve
    it("should buy tokens on the bonding curve", async function () {
        const daoAddress = addr1;
        const subTokenId = await bondingCurve.initAgent(daoAddress);

        // Call the buy function
        await bondingCurve.buy(subTokenId, ethers.parseEther("100"));

        // Verify the pool's total supply and reserve balance
        const pool = await bondingCurve.pools(subTokenId);
        expect(pool.totalSupply).to.equal(ethers.parseEther("100"));
        expect(pool.reserveBalance).to.equal(ethers.parseEther("100"));
    });

    // Test selling tokens on the bonding curve
    it("should sell tokens on the bonding curve", async function () {
        const daoAddress = addr1;
        const subTokenId = await bondingCurve.initAgent(daoAddress);

        // Call the buy function to add tokens
        await bondingCurve.buy(subTokenId, ethers.parseEther("100"));

        // Call the sell function
        await bondingCurve.sell(subTokenId, ethers.parseEther("50"));

        // Verify the pool's total supply and reserve balance
        const pool = await bondingCurve.pools(subTokenId);
        expect(pool.totalSupply).to.equal(ethers.parseEther("50"));
        expect(pool.reserveBalance).to.equal(ethers.parseEther("50"));
    });
}); 