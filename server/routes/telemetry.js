/**
 * Captures telemetry and creates events using Ambrosus API
 */
const debug   = require("debug")("api:routes"),
      express = require('express');

let router = express.Router();

/**
 * Using GET to make it easier to send sensor data
 */
router.get('/send', function(req, res) {
    console.log(err);
    return res.status(500).json({err: err});

});

module.exports = router;
