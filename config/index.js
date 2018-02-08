const nconf    = require("nconf"),
      path     = require("path"),
      defaults = require("./defaults.json");

const configPath = path.join(__dirname, '../config');
nconf.env().argv();
nconf.file({file: path.join(configPath, (nconf.get('NODE_ENV') || "dev") + ".json")});
nconf.defaults(defaults);

module.exports = nconf;
