const express = require("express");
const router = express.Router();
const patronController = require("../controllers/patronController");

router.get("/", patronController.getPatrons);
router.post("/add-patron", patronController.addPatron);
router.delete("/:id", patronController.deletePatron);

module.exports = router;
