pragma solidity ^0.4.18;

import "./Shipment.sol";

contract Inventory {

    mapping(address => mapping(bytes32 => Shipment)) public shipments;
    mapping(address => mapping(bytes32 => uint)) public failing;


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
        uint8 _minTemperature,
        uint8 _maxTemperature,
        uint8 _minHumidity,
        uint8 _maxHumidity,
        uint8 _minAirPressure,
        uint8 _maxAirPressure
    )
        public
    {
        shipments[_owner][_shipmentId] = new Shipment(_owner, _shipmentId, _name,
            _minTemperature, _maxTemperature,
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
        uint8 _temperature,
        uint8 _humidity,
        uint8 _airPressure
    )
        public
    {
        Shipment aShipment = shipments[_owner][_shipmentId];
        aShipment.addTelemetry(_eventId, _temperature, _humidity, _airPressure);
        failing[_owner][_shipmentId] = aShipment.isFailing(_temperature, _humidity, _airPressure);
    }

    function status(
        address _owner,
        bytes32 _shipmentId
    ) public view returns (uint) 
    {
        return 1-failing[_owner][_shipmentId];
    }

}