const pool = require("../database/db-connector");

// Retrieve rentals
exports.getRentals = () => pool.promise().query("CALL GetRentals()");

// Add a rental
exports.addRental = (vinylID, patronID, rentalDate) =>
  pool
    .promise()
    .query("CALL AddRental(?, ?, ?)", [vinylID, patronID, rentalDate]);

// Delete a rental
exports.deleteRental = (rentalId) =>
  pool.promise().query("CALL DeleteRental(?)", [rentalId]);
