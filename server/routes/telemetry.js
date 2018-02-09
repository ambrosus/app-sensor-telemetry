/**
 * Captures telemetry and creates events using Ambrosus API
 */
const debug   = require("debug")("api:routes"),
      express = require('express'),
      rp      = require('request-promise');

let router = express.Router();

/**
 * Using GET to make it easier to send sensor data
 */
router.get('/send', function(req, res) {
    let owner       = req.query.owner;
    let secret      = req.query.secret;
    let shipmentId  = req.query.shipmentId;
    let name        = req.query.name;
    let temp        = req.query.temp;
    let humidity    = req.query.humidity;
    let airpressure = req.query.airpressure;

    debug(req.query);

    if(!shipmentId || !name) {
        return res.status(400).json({err: "shipmentId and name are required"});
    }

    rp({
        uri: "https://network.ambrosus.com/assets/find/shipmentId:" + shipmentId,
        json: true
    })
    .then(function(assets) {
        if(assets.length === 0) {
            debug("Shipment not found. Creating shipment as a new asset.");
            return createAsset(owner, secret, shipmentId);
        } else {
            debug("Found a shipment");
            return assets[0];
        }
    })
    .then(function(asset) {
        debug("Adding events to asset:", asset);
        return createEvent(owner, secret, asset.id, temp, humidity, airpressure);
    })
    .then(function(parsedBody) {
        return res.status(200).json(parsedBody);
    })
    .catch(function(err) {
        return res.status(500).json({err: err});
    });
});

/**
 * Returns a promise which creates a new asset.
 * @param owner
 * @param secret
 * @param shipmentId
 * @returns {*}
 */
function createAsset(owner, secret, shipmentId) {
    return rp({
        method: 'POST',
        uri: "https://network.ambrosus.com/assets/",
        body: {
            "content": {
                "secret": secret,
                "data": {
                    "creator": owner,
                    "owner": owner,
                    "name": name,
                    "created_at": Date.now(),
                    "identifiers": {
                        "shipmentId": shipmentId
                    }
                }
            }
        },
        json: true
    });
}

/**
 * Returns a promise to POST http request.
 * @param owner
 * @param secret
 * @param assetId
 * @param temp
 * @param humidity
 * @param airpressure
 * @returns {*}
 */
function createEvent(owner, secret, assetId, temp, humidity, airpressure) {
    return rp({
        method: 'POST',
        uri: "https://network.ambrosus.com/assets/" + assetId + "/events",
        body: {
            "content": {
                "secret": secret,
                "data": {
                    "type": "Telemetry",
                    "subject": assetId,
                    "creator": owner,
                    "created_at": Date.now(),
                    "temp": temp,
                    "humidity": humidity,
                    "airpressure": airpressure
                }
            }
        },
        json: true
    });
}

module.exports = router;
