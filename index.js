require("coffee-script");
HPUB = {};
HPUB.Reader = require('./lib/reader').Reader;
HPUB.Writer = require('./lib/writer').Writer;

module.exports = HPUB;