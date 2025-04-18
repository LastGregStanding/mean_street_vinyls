const Vinyl = require("../models/vinylModel");

exports.getVinyls = async (req, res) => {
  try {
    const [results] = await Vinyl.getVinylsWithArtists();
    res.json(results);
  } catch (error) {
    console.error("Error retrieving vinyls:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.getVinylDropdown = async (req, res) => {
  try {
    const [results] = await Vinyl.getVinylDropdown();
    res.json(results);
  } catch (error) {
    console.error("Error retrieving vinyls for dropdown:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.addVinyl = async (req, res) => {
  const { title, label, yearReleased, artistID } = req.body;
  try {
    await Vinyl.addVinyl(title, label, yearReleased, artistID);
    res.json({ success: true });
  } catch (error) {
    console.error("Error adding vinyl:", error);
    res.status(500).json({ error: "Database error." });
  }
};
