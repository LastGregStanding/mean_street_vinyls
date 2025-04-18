const express = require("express");
const router = express.Router();
const vinylController = require("../controllers/vinylController");

router.get("/", vinylController.getVinyls);
router.post("/add-vinyl", vinylController.addVinyl);
router.delete("/:id", vinylController.deleteVinyl);

module.exports = router;
