const pool = require("../database/db-connector");

// Get all artist
exports.getArtists = () => pool.promise().query("CALL GetArtists()");

// Add an artist
exports.addArtist = (artistName, genre, countryOrigin) =>
  pool
    .promise()
    .query("CALL AddArtist(?, ?, ?)", [artistName, genre, countryOrigin]);

// Delete an artist
exports.deleteArtist = (artistId) =>
  pool.promise().query("CALL DeleteArtist(?)", [artistId]);
