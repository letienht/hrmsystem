// src/routes/auth.js
const express = require("express");
const router = express.Router();
const authController = require("../controller/authController");

router.post("/login", authController.login);
router.post("/register", authController.register);
router.post("/refresh", authController.refresh);
module.exports = router;
