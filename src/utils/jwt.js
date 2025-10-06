const jwt = require("jsonwebtoken");

const generateToken = (user) => {
  return jwt.sign(
    { id: user._id, role: user.role },
    process.env.JWT_SECRET || "supersecret",
    { expiresIn: "1h" } // access token
  );
};

const generateRefreshToken = (user) => {
  return jwt.sign(
    { id: user._id },
    process.env.JWT_REFRESH_SECRET || "superrefresh",
    { expiresIn: "7d" } // refresh token
  );
};

module.exports = { generateToken, generateRefreshToken };
