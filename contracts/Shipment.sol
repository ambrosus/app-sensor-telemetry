pragma solidity ^0.4.18;

contract Shipment {

    struct Telemetry {
        bytes32 eventId;
        uint8 temperature;
        uint8 humidity;
        uint8 airPressure;
        uint timestamp;
    }

    struct Constraints {
        uint8 minTemperature;
        uint8 maxTemperature;
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
        uint8 _minTemperature,
        uint8 _maxTemperature,
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

        constraints.minTemperature = _minTemperature;
        constraints.maxTemperature = _maxTemperature;
        constraints.minHumidity = _minHumidity;
        constraints.maxHumidity = _maxHumidity;
        constraints.minAirPressure = _minAirPressure;
        constraints.maxAirPressure = _maxAirPressure;
    }

    function addTelemetry(
        bytes32 _eventId,
        uint8 _temperature,
        uint8 _humidity,
        uint8 _airPressure
    )
        public
    {
        readings.push(Telemetry(_eventId, _temperature, _humidity, _airPressure, now));
    }

    function isFailing(
        uint8 _temperature,
        uint8 _humidity,
        uint8 _airPressure
    ) constant public returns (uint) {
        if (_temperature < constraints.minTemperature || _temperature > constraints.maxTemperature) {
            return 1;
        }

        if (_humidity < constraints.minHumidity || _humidity > constraints.maxHumidity) {
            return 1;
        }

        if (_airPressure < constraints.minAirPressure || _airPressure > constraints.maxAirPressure) {
            return 1;
        }

        return 0;
    }
}
