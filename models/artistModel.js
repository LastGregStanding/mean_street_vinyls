const pool = require("../database/db-connector");

// Get all patrons
exports.getArtists = () => pool.promise().query("CALL GetArtists()");

// Add a patron
exports.addArtist = (artistName, genre, countryOrigin) =>
  pool
    .promise()
    .query("CALL AddArtist(?, ?, ?)", [artistName, genre, countryOrigin]);
