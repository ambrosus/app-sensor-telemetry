/**
 * Captures telemetry and creates events using Ambrosus API
 */
const debug = require('debug')('api:routes'),
  express = require('express'),
  rp = require('request-promise');

let router = express.Router()

/**
 * Using GET to make it easier to send sensor data
 */
router.get('/telemetry', function (req, res) {
  let owner = req.query.owner
  let secret = req.query.secret
  let shipmentId = req.query.shipmentId
  let name = req.query.name
  let temp = req.query.temp
  let humidity = req.query.humidity
  let airpressure = req.query.airpressure

  debug(req.query)

  if (!shipmentId || !name) {
    return res.status(400).json({err: 'shipmentId and name are required'})
  }

  rp({
    uri: 'https://network.ambrosus.com/assets/find/shipmentId:' + shipmentId,
    json: true,
  }).then(function (assets) {
    if (assets.length === 0) {
      debug('Shipment not found. Creating shipment as a new asset.')
      return createAsset(owner, secret, shipmentId, name)
    } else {
      debug('Found a shipment')
      return assets[0]
    }
  }).then(function (asset) {
    debug('Adding events to asset:', asset)
    return createEvent(req.inventoryContract, req.web3, owner, secret, asset.id, temp, humidity,
      airpressure, shipmentId)
  }).then(function (parsedBody) {
    return res.status(200).json(parsedBody)
  }).catch(function (err) {
    debug(err)
    return res.status(500).json({err: err})
  })
})

router.get('/shipment', async (req, res) => {
  const {
    owner, shipmentId, name, minTemp, maxTemp, minHumidity, maxHumidity,
    minAirPressure, maxAirPressure,
  } = req.query
  const sender = (await req.web3.eth.getAccounts())[0]
  await req.inventoryContract.methods.addShipment(
    owner, req.web3.utils.toHex(shipmentId), name,
    minTemp, maxTemp, minHumidity, maxHumidity,
    minAirPressure, maxAirPressure)
  .send({
    from: sender,
    gas: 6000000,
  })
  return res.sendStatus(200);
});

router.get('/status', async (req, res) => {
  const {owner, shipmentId} = req.query;
  const status = await req.inventoryContract.methods.status(
    owner, req.web3.utils.toHex(shipmentId)
  ).call();
  return res.status(200).send({status: status>0?'OK':'Something is wrong' });
})

/**
 * Returns a promise which creates a new asset.
 * @param owner
 * @param secret
 * @param shipmentId
 * @returns {*}
 */
function createAsset (owner, secret, shipmentId, name) {
  return rp({
    method: 'POST',
    uri: 'https://network.ambrosus.com/assets/',
    body: {
      'content': {
        'secret': secret,
        'data': {
          'creator': owner,
          'owner': owner,
          'name': name,
          'created_at': Date.now(),
          'identifiers': {
            'shipmentId': shipmentId,
          },
        },
      },
    },
    json: true,
  })
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
function createEvent (
  contract, web3, owner, secret, assetId, temp, humidity, airpressure, shipmentId) {
  return rp({
    method: 'POST',
    uri: 'https://network.ambrosus.com/assets/' + assetId + '/events',
    body: {
      'content': {
        'secret': secret,
        'data': {
          'type': 'Telemetry',
          'subject': assetId,
          'creator': owner,
          'created_at': Date.now(),
          'temp': temp,
          'humidity': humidity,
          'airpressure': airpressure,
        },
      },
    },
    json: true,
  }).then(async (event) => {
    const sender = (await web3.eth.getAccounts())[0]
    await contract.methods.addTelemetry(owner, web3.utils.toHex(shipmentId),
      web3.utils.toHex(event.id), temp, humidity, airpressure)
    .send({
      from: sender,
      gas: 3000000,
    })
    return event;
  })
}

module.exports = router
