/**
 * Send alerts
 */
const debug   = require("debug")("api:routes"),
    express = require('express');

let router = express.Router();

/**
 * Send alerts to a subscriber
 */
router.get('/', function(req, res) {
    return res.status(200).send({}).end();
});

module.exports = router;
