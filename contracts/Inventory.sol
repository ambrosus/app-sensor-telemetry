pragma solidity ^0.4.17;

import "./Shipment.sol";

contract Inventory {

    mapping(address => mapping(bytes32 => Shipment)) public shipments;

    /**
     * Constructor to keep track of shipments
     */
    function Inventory()
        public
    {
    }

    /**
     * Add a new shipment
     */
    function addShipment(
        address _owner,
        bytes32 _shipmentId,
        string _name,
        uint8 _minTempCelcius,
        uint8 _maxTempCelcius,
        uint8 _minHumidity,
        uint8 _maxHumidity,
        uint8 _minAirPressure,
        uint8 _maxAirPressure
    )
        public
    {
        shipments[_owner][_shipmentId] = new Shipment(_owner, _shipmentId, _name,
            _minTempCelcius, _maxTempCelcius,
            _minHumidity, _maxHumidity,
            _minAirPressure, _maxAirPressure);
    }

    /**
     * Save sensor measurements. These are average of last 5 mins.
     */
    function addTelemetry(
        address _owner,
        bytes32 _shipmentId,
        bytes32 _eventId,
        uint8 _tempCelcius,
        uint8 _humidity,
        uint8 _airPressure
    )
        public
    {
        Shipment aShipment = shipments[_owner][_shipmentId];
        aShipment.addTelemetry(_eventId, _tempCelcius, _humidity, _airPressure);
    }

}
