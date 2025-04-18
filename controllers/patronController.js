const Patron = require("../models/patronModel");

exports.getPatrons = async (req, res) => {
  try {
    const [results] = await Patron.getPatrons();
    res.json(results);
  } catch (error) {
    console.error("Error retrieving patrons:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.addPatron = async (req, res) => {
  const { firstName, lastName, membershipDate } = req.body;
  try {
    await Patron.addPatron(firstName, lastName, membershipDate);
    res.json({ success: true });
  } catch (error) {
    console.error("Error adding patron:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.deletePatron = async (req, res) => {
  const patronId = req.params.id;
  try {
    Patron.deletePatron(patronId);
    res.json({ success: true });
  } catch (error) {
    console.error("Error deleting patron:", error);
    res.status(500).json({ error: "Database error." });
  }
};
