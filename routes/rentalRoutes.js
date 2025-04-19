const express = require("express");
const router = express.Router();
const rentalController = require("../controllers/rentalController");

router.get("/", rentalController.getRentals);
router.get("/:id", rentalController.getSpecificRental);
router.post("/add-rental", rentalController.addRental);
router.patch("/:id", rentalController.updateReturnDates);
router.delete("/:id", rentalController.deleteRental);

module.exports = router;
