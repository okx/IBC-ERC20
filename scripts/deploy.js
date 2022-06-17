const { ethers } = require("hardhat");

async function deploy(symbol, decimals) {
    const ABI = [
        "function initialize(string memory denom_, uint8 decimals_)"
    ]
    const interface = new ethers.utils.Interface(ABI);
    const calldata = interface.encodeFunctionData("initialize", [symbol, decimals]);
    console.log("calldata: " + calldata)

    const ERC20Factory = await ethers.getContractFactory("ModuleERC20");
    const erc20 = await ERC20Factory.deploy();
    await erc20.deployed();
    console.log("implementation address: " + erc20.address)

    const ProxyFactory = await ethers.getContractFactory("ModuleERC20Proxy"); 
    const proxy = await ProxyFactory.deploy(erc20.address, calldata);
    await proxy.deployed();
    console.log("proxy address: " + proxy.address)

    console.log("done")
}


const symbol = "testToken1"
const decimals = 18

deploy(symbol, decimals)
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });