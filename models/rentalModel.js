const pool = require("../database/db-connector");

// Retrieve rentals
exports.getRentals = () => pool.promise().query("CALL GetRentals()");

// Retrieve specific rental
exports.getSpecificRental = (rentalID) =>
  pool.promise().query("CALL GetSpecificRental(?)", [rentalID]);

// Add a rental
exports.addRental = (vinylID, patronID, rentalDate) =>
  pool
    .promise()
    .query("CALL AddRental(?, ?, ?)", [vinylID, patronID, rentalDate]);

// Update return date
exports.updateReturnDate = (rentalID, newReturnDate) =>
  pool
    .promise()
    .query("CALL UpdateReturnDate(?, ?)", [rentalID, newReturnDate]);

// Delete a rental
exports.deleteRental = (rentalId) =>
  pool.promise().query("CALL DeleteRental(?)", [rentalId]);
