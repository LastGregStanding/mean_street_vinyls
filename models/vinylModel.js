const pool = require("../database/db-connector");

// Retrieve vinyls with their artists
exports.getVinylsWithArtists = () =>
  pool.promise().query("CALL GetVinylsWithArtists()");

// Fill in the vinyl dropdown
exports.getVinylDropdown = () => pool.promise().query("CALL GetVinyls()");

// Add a vinyl
exports.addVinyl = (title, label, yearReleased, artistID) =>
  pool
    .promise()
    .query("CALL AddVinyl(?, ?, ?, ?)", [title, label, yearReleased, artistID]);
