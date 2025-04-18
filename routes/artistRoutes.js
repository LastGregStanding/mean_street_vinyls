const express = require("express");
const router = express.Router();
const artistController = require("../controllers/artistController");

router.get("/", artistController.getArtists);
router.post("/add-artist", artistController.addArtist);
router.delete("/:id", artistController.deleteArtist);

module.exports = router;
