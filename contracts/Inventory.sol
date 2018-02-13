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
        uint256 _minTempCelcius,
        uint256 _maxTempCelcius,
        uint256 _minHumidity,
        uint256 _maxHumidity,
        uint256 _minAirPressure,
        uint256 _maxAirPressure
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
        uint256 _tempCelcius,
        uint256 _humidity,
        uint256 _airPressure
    )
        public
    {
        Shipment aShipment = shipments[_owner][_shipmentId];
        aShipment.addTelemetry(_eventId, _tempCelcius, _humidity, _airPressure);
        failing[_owner][_shipmentId] = aShipment.isFailing(_tempCelcius, _humidity, _airPressure);
    }

    function status(
        address _owner,
        bytes32 _shipmentId
    ) public view returns (uint){
        return 1-failing[_owner][_shipmentId];
    }



}
