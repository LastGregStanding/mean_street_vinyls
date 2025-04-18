const express = require("express");
const path = require("path");
const app = express();

require("dotenv").config();
app.use(express.json());

//  Static files
app.use(express.static(path.join(__dirname, "public")));

// Routes
const patronRoutes = require("./routes/patronRoutes");
app.use("/api/patrons", patronRoutes);

const artistRoutes = require("./routes/artistRoutes");
app.use("/api/artists", artistRoutes);

const vinylRoutes = require("./routes/vinylRoutes");
app.use("/api/vinyls", vinylRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).send("404 - Page Not Found");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on PORT ${PORT}`);
});
