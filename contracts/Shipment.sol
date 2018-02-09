pragma solidity ^0.4.0;

contract Shipment {

    struct Telemetry {
        bytes32 eventId;
        uint8 tempCelcius;
        uint8 humidity;
        uint8 airPressure;
        uint timestamp;
    }

    struct Constraints {
        uint8 minTempCelcius;
        uint8 maxTempCelcius;
        uint8 minHumidity;
        uint8 maxHumidity;
        uint8 minAirPressure;
        uint8 maxAirPressure;
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
    event LogTempConstraintViolation(bytes32 shipmentId, uint8 actualValue, uint8 minValue, uint8 maxValue);

    /// Humidity reading not in range
    event LogHumidityConstraintViolation(bytes32 shipmentId, uint8 actualValue, uint8 minValue, uint8 maxValue);

    /// Air pressre reading not in range
    event LogAirPressureConstraintViolation(bytes32 shipmentId, uint8 actualValue, uint8 minValue, uint8 maxValue);


    /**
     * Create a new shipment with constraints on sensor readings.
     */
    function Shipment(
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
        uint8 _tempCelcius,
        uint8 _humidity,
        uint8 _airPressure
    )
        public
    {
        readings.push(Telemetry(_eventId, _tempCelcius, _humidity, _airPressure, now));

        if(_tempCelcius < constraints.minTempCelcius || _tempCelcius > constraints.maxTempCelcius) {
            LogTempConstraintViolation(shipmentId, _tempCelcius, constraints.minTempCelcius, constraints.maxTempCelcius);
        }

        if(_humidity < constraints.minHumidity || _humidity > constraints.maxHumidity) {
            LogHumidityConstraintViolation(shipmentId, _humidity, constraints.minHumidity, constraints.maxHumidity);
        }

        if(_airPressure < constraints.minAirPressure || _airPressure > constraints.maxAirPressure) {
            LogAirPressureConstraintViolation(shipmentId, _airPressure, constraints.minAirPressure, constraints.maxAirPressure);
        }
    }
}
