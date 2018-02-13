/**
 * Shipment scenarios.
 */
const Shipment  = artifacts.require("./Shipment.sol");
const Inventory = artifacts.require("./Inventory.sol");

contract('Shipment API', (accounts) => {

    const [owner] = accounts;

    before(async () => {
        this.inventory  = await Inventory.deployed();
        this.shipmentId = "123";

        await this.inventory.addShipment(owner, this.shipmentId, "Tylenol", 1, 5, 40, 50, 1100, 1150);
    });

    describe("Storage and retrieval", () => {

        it("should store sensor readings", async () => {
            await this.inventory.addTelemetry(owner, this.shipmentId, "000", 4, 45, 100);
        });

        it("should trigger a violation event", async () => {
            let result = await this.inventory.addTelemetry(owner, this.shipmentId, "000", 8, 45, 1100);
        });
    });

});