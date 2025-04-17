const pool = require("../database/db-connector");

// Get all patrons
exports.getPatrons = () => pool.promise().query("CALL GetPatrons()");

// Add a patron
exports.addPatron = (firstName, lastName, membershipDate) =>
  pool
    .promise()
    .query("CALL AddPatron(?, ?, ?)", [firstName, lastName, membershipDate]);
