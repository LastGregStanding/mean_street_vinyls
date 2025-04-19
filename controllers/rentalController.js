const Rental = require("../models/rentalModel");

exports.getRentals = async (req, res) => {
  try {
    const [results] = await Rental.getRentals();
    res.json(results);
  } catch (error) {
    console.error("Error retrieving rentals:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.addRental = async (req, res) => {
  const { vinylID, patronID, rentalDate } = req.body;
  try {
    await Rental.addRental(vinylID, patronID, rentalDate);
    res.json({ success: true });
  } catch (error) {
    console.error("Error adding rental:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.getSpecificRental = async (req, res) => {
  const rentalId = req.params.id;
  try {
    const [results] = await Rental.getSpecificRental(rentalId);
    res.json(results);
  } catch (error) {
    console.error("Error retrieving rentals:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.updateReturnDates = async (req, res) => {
  const { rentalID, newReturnDate } = req.body;
  try {
    Rental.updateReturnDate(rentalID, newReturnDate);
    res.json({ success: true });
  } catch (error) {
    console.error("Error updating return date:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.deleteRental = async (req, res) => {
  const rentalId = req.params.id;
  try {
    Rental.deleteRental(rentalId);
    res.json({ success: true });
  } catch (error) {
    console.error("Error deleting rental:", error);
    res.status(500).json({ error: "Database error." });
  }
};
