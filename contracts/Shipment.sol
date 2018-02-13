pragma solidity ^0.4.18;

contract Shipment {

    struct Telemetry {
        bytes32 eventId;
        uint256 tempCelcius;
        uint256 humidity;
        uint256 airPressure;
        uint timestamp;
    }

    struct Constraints {
        uint256 minTempCelcius;
        uint256 maxTempCelcius;
        uint256 minHumidity;
        uint256 maxHumidity;
        uint256 minAirPressure;
        uint256 maxAirPressure;
    }

    Telemetry[] readings;

    Constraints constraints;

    address owner;

    bytes32 shipmentId;

    string name;

    /*
     * Events
     */

    /// Temperature reading not in range
    event LogTempConstraintViolation(bytes32 shipmentId, uint256 actualValue, uint256 minValue, uint256 maxValue);

    /// Humidity reading not in range
    event LogHumidityConstraintViolation(bytes32 shipmentId, uint256 actualValue, uint256 minValue, uint256 maxValue);

    /// Air pressre reading not in range
    event LogAirPressureConstraintViolation(bytes32 shipmentId, uint256 actualValue, uint256 minValue, uint256 maxValue);


    /**
     * Create a new shipment with constraints on sensor readings.
     */
    function Shipment(
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
        owner = _owner;
        shipmentId = _shipmentId;
        name = _name;

        constraints.minTempCelcius = _minTempCelcius;
        constraints.maxTempCelcius = _maxTempCelcius;
        constraints.minHumidity = _minHumidity;
        constraints.maxHumidity = _maxHumidity;
        constraints.minAirPressure = _minAirPressure;
        constraints.maxAirPressure = _maxAirPressure;
    }

    function addTelemetry(
        bytes32 _eventId,
        uint256 _tempCelcius,
        uint256 _humidity,
        uint256 _airPressure
    )
        public
    {
        readings.push(Telemetry(_eventId, _tempCelcius, _humidity, _airPressure, now));
    }

    function isFailing(
        uint256 _tempCelcius,
        uint256 _humidity,
        uint256 _airPressure
    ) constant public returns (uint) {
        if(_tempCelcius < constraints.minTempCelcius || _tempCelcius > constraints.maxTempCelcius) {
            return 1;
        }

        if(_humidity < constraints.minHumidity || _humidity > constraints.maxHumidity) {
            return 1;
        }

        if(_airPressure < constraints.minAirPressure || _airPressure > constraints.maxAirPressure) {
            return 1;
        }

        return 0;
    }
}
