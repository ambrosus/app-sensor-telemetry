const Inventory = artifacts.require("./Inventory.sol");
const Shipment  = artifacts.require("./Shipment.sol");

module.exports = function test(deployer) {
    deployer.deploy(Inventory)
    .catch((err) => {
        console.error("Deployment failed", err);
    })
};