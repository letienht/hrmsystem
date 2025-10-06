// src/app.js
const express = require("express");
// console.log("tienlv", __dirname);
const authRoutes = require("./routes/auth");
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Routes

app.use("/api/auth", authRoutes);

// Test protected API
const authMiddleware = require("./middlewares/authMiddleware");
app.get("/api/me", authMiddleware, (req, res) => {
  res.json({ message: "Welcome!", user: req.user });
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`HRM API running on port ${PORT}`));
