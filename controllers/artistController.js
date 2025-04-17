const Artist = require("../models/artistModel");

exports.getArtists = async (req, res) => {
  try {
    const [results] = await Artist.getArtists();
    res.json(results);
  } catch (error) {
    console.error("Error retrieving artists:", error);
    res.status(500).json({ error: "Database error." });
  }
};

exports.addArtist = async (req, res) => {
  const { artistName, genre, countryOrigin } = req.body;
  try {
    await Artist.addArtist(artistName, genre, countryOrigin);
    res.json({ success: true });
  } catch (error) {
    console.error("Error adding artist:", error);
    res.status(500).json({ error: "Database error." });
  }
};
