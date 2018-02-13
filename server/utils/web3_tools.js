const Web3 = require('web3');

async function createWeb3() {
  const web3 = new Web3();

  // take the RPC value from the config and create a provider
  const rpc = process.env.WEB3_RPC;
  if (/^((?:http)|(?:ws)):\/\//g.test(rpc)) {
    web3.setProvider(rpc);
  } else if (rpc == 'ganache') {
    // import in code with purpose:D
    const Ganache = require('ganache-core');
    const defaultBalance = "1000000000000000000000000000";
    const ganacheOptions = {
      accounts: [{ balance: defaultBalance }]
    };
    web3.setProvider(Ganache.provider(ganacheOptions));
    web3.eth.defaultAccount = (await web3.eth.getAccounts())[0];
  } else {
    throw new Error('A configuration value for web3 rpc server is missing');
  }

  return web3;
}

async function getDefaultAccount(web3) {
  const defaultAccount = web3.eth.defaultAccount;
  if (!defaultAccount) {
    throw new Error('web3 doesn\'t have a default account set. Check your configuration');
  }
  return defaultAccount;
}

async function deployContract(web3, contractJson, args = [], options = {}) {
  const defaultAccount = await getDefaultAccount(web3);
  options = {
    from: defaultAccount,
    gas: defaultGas,
    ...options,
  };
  const contract = await new web3.eth.Contract(contractJson.abi)
  .deploy({ data: contractJson.bytecode, arguments: args })
  .send(options);
  contract.setProvider(web3.currentProvider);
  return contract;
}


module.exports = createWeb3;
