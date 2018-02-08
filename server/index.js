/**
 * Application starts here.
 */
const debug      = require("debug")("api:server"),
      cors       = require("cors"),
      express    = require("express"),
      bodyParser = require("body-parser");

let app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

app.use("/alert", require("./routes/alert"));
app.use("/telemetry", require("./routes/telemetry"));

module.exports = app;

