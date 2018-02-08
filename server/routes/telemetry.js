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
    // account=123&shipmentId=123&temp=22&humidity=38&airpressure=1011
    let owner       = req.query.owner;
    let secret       = req.query.secret;
    let shipmentId  = req.query.shipmentId;
    let name        = req.query.name;
    let temp        = req.query.temp;
    let humidity    = req.query.humidity;
    let airpressure = req.query.airpressure;

    console.log(req.query);

    let options = {
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
    };

    rp(options)
    .then(function(parsedBody) {
        return res.status(200).json(parsedBody);
    })
    .catch(function(err) {
        return res.status(500).json({err: err});
    });
});

module.exports = router;
