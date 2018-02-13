/**
 * Application starts here.
 */
const debug      = require("debug")("api:server"),
      cors       = require("cors"),
      express    = require("express"),
      bodyParser = require("body-parser"),
      createWeb3 = require('./utils/web3_tools'),
      inventory  = require('../build/contracts/Inventory.json'),
      shipment  = require('../build/contracts/Shipment.json');


const injectWeb3 = (web3) => (req, res, next) => {
  req.web3 = web3;
  req.inventoryContract = new web3.eth.Contract(inventory.abi,
    inventory.networks[Object.keys(inventory.networks)[0]].address);
  next();
}



let app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

createWeb3().then(web3 => {
  app.use("/", injectWeb3(web3), require("./routes/telemetry"));
});


module.exports = app;

