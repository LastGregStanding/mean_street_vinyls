const express = require("express");
const router = express.Router();
const rentalController = require("../controllers/rentalController");

router.get("/", rentalController.getRentals);
router.post("/add-rental", rentalController.addRental);
router.delete("/:id", rentalController.deleteRental);

module.exports = router;
