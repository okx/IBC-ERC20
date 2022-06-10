const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");

describe("module erc20 proxy", function () {
    let owner, alice;
    let erc20;
    let ERC20Factory;
    let ProxyFactory;
    let interface;
    let proxy;

    before(async () => {
        
        [owner, alice] = await ethers.getSigners();

        const ABI = [
            "function initialize(string memory denom_, uint8 decimals_)",
            "function transfer(address to, uint256 amount)"
        ]
        interface = new ethers.utils.Interface(ABI);

        ProxyFactory = await ethers.getContractFactory("MockModuleERC20Proxy");

        ERC20Factory = await ethers.getContractFactory("MockModuleERC20");
        erc20 = await ERC20Factory.deploy();
    })

    it("deploy proxy", async () => {
        
        const tokenSymbol1 = "test1"
        const tokenSymbol2 = "test2"
        const tokenDecimals = 18
        const calldata1 = interface.encodeFunctionData("initialize", [tokenSymbol1, tokenDecimals]);
        const calldata2 = interface.encodeFunctionData("initialize", [tokenSymbol2, tokenDecimals]);
        
        const proxy1 = await ProxyFactory.deploy(erc20.address, calldata1);
        const token1 = await ERC20Factory.attach(proxy1.address);

        const proxy2 = await ProxyFactory.deploy(erc20.address, calldata2);
        const token2 = await ERC20Factory.attach(proxy2.address);

        const symbol1 = await token1.symbol();
        const symbol2 = await token2.symbol();

        expect(symbol1).to.equal(tokenSymbol1);
        expect(symbol2).to.equal(tokenSymbol2);

        console.log("symbol1: " + symbol1)
        console.log("symbol2: " + symbol2)

        proxy = proxy1;
    })

    it("test upgradeTo", async () => {
        const newToken = await ERC20Factory.deploy();
        await proxy.upgradeTo(newToken.address);

        const newImplementation = await upgrades.erc1967.getImplementationAddress(proxy.address);
        expect(newImplementation).to.equal(newToken.address);

        const token = await ERC20Factory.attach(proxy.address);
        const symbol = await token.symbol();
        expect(symbol).to.equal("test1");

        await token.mint_by_okc_module(owner.address, ethers.utils.parseEther("10000"));
        expect(await token.balanceOf(owner.address)).to.equal(ethers.utils.parseEther("10000"));
    })

    it("test upgradeToAndCall", async () => {
        const newToken = await ERC20Factory.deploy();
        const calldata = interface.encodeFunctionData("transfer", [alice.address, ethers.utils.parseEther("10000")]);
        await proxy.upgradeToAndCall(newToken.address, calldata);

        const newImplementation = await upgrades.erc1967.getImplementationAddress(proxy.address);
        expect(newImplementation).to.equal(newToken.address);
        
        const token = await ERC20Factory.attach(proxy.address);
        expect(await token.balanceOf(owner.address)).to.equal(ethers.utils.parseEther("0"));
        expect(await token.balanceOf(alice.address)).to.equal(ethers.utils.parseEther("10000"));
    })

    it("test changeAdmin", async () => {
        await proxy.changeAdmin(alice.address);

        const newAdmin = await upgrades.erc1967.getAdminAddress(proxy.address);
        expect(newAdmin).to.equal(alice.address);
    })
})