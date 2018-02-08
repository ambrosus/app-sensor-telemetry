pragma solidity ^0.4.0;

contract Shipment {

    struct Telemetry {
        bytes32 eventId;
        uint8 tempCelcius;
        uint8 humidity;
        uint8 airPressure;
        uint timestamp;
    }

    Telemetry[] readings;

    address owner;

    bytes32 shipmentId;

    string name;

    /**
     * Constructor
     */
    function Shipment(
        address _owner,
        bytes32 _shipmentId,
        string _name
    )
        public
    {
        owner = _owner;
        shipmentId = _shipmentId;
        name = _name;
    }

    function addTelemetry(
        bytes32 _eventId,
        uint8 _tempCelcius,
        uint8 _humidity,
        uint8 _airPressure
    )
        public
    {
        readings.push(Telemetry(_eventId, _tempCelcius, _humidity, _airPressure, now));
    }
}
