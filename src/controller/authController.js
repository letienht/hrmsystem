// src/controllers/authController.js
const pool = require("../db/connectorDB");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { generateToken, generateRefreshToken } = require("../utils/jwt");
const JWT_SECRET = process.env.JWT_SECRET || "supersecret";
const JWT_EXPIRES = "1h"; // Access token 1h

// Refresh Token
exports.refresh = (req, res) => {
  const { token } = req.body;
  if (!token)
    return res.status(401).json({ message: "Không có refresh token" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET);
    const accessToken = generateToken({ _id: decoded.id, role: decoded.role });
    res.json({ accessToken });
  } catch {
    res.status(403).json({ message: "Refresh token không hợp lệ" });
  }
};

// resgister api
exports.register = async (req, res) => {
  const { username, email, phone, password, role } = req.body;

  // ✅ Validate
  if (!username || !email || !phone || !password) {
    return res
      .status(400)
      .json({ message: "Vui lòng nhập đủ username, email, phone và password" });
  }

  try {
    // ✅ Kiểm tra email đã tồn tại
    const emailExists = await pool.query("SELECT * FROM users WHERE email=$1", [
      email,
    ]);
    if (emailExists.rows.length > 0) {
      return res.status(409).json({ message: "Email đã tồn tại" });
    }

    // ✅ Kiểm tra phone đã tồn tại
    const phoneExists = await pool.query("SELECT * FROM users WHERE phone=$1", [
      phone,
    ]);
    if (phoneExists.rows.length > 0) {
      return res.status(409).json({ message: "Số điện thoại đã tồn tại" });
    }

    // ✅ Mã hoá password
    const hashedPassword = await bcrypt.hash(password, 10);

    // ✅ Thêm user mới
    const insertUser = await pool.query(
      `INSERT INTO users (username, email, phone, password_hash)
       VALUES ($1, $2, $3, $4)
       RETURNING id, username, email, phone`,
      [username, email, phone, hashedPassword]
    );

    const user = insertUser.rows[0];
    const accessToken = generateToken(user);
    const refreshToken = generateRefreshToken(user);

    res.status(201).json({
      message: "Đăng ký thành công",
      user,
      accessToken,
      refreshToken,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};

// Login API
exports.login = async (req, res) => {
  console.log("BODY RECEIVED:", req.body); // debug
  const { username, password } = req.body;

  try {
    // 1. Lấy user từ DB
    const result = await pool.query(
      `SELECT id, username, email, password_hash, is_active
       FROM users WHERE username = $1`,
      [username]
    );
    console.log("DB RESULT:", result); // debug
    if (result.rowCount === 0) {
      return res.status(401).json({ message: "Invalid username or password" });
    }

    const user = result.rows[0];
    if (!user.is_active) {
      return res.status(403).json({ message: "User is inactive" });
    }

    // 2. Check password
    // const validPassword = await bcrypt.compare(password, user.password_hash);
    // if (!validPassword) {
    //   return res.status(401).json({ message: "Invalid username or password" });
    // }

    // 3. Lấy roles
    const rolesResult = await pool.query(
      `SELECT r.name
       FROM user_roles ur
       JOIN roles r ON ur.role_id = r.id
       WHERE ur.user_id = $1`,
      [user.id]
    );
    const roles = rolesResult.rows.map((r) => r.name);

    // 4. Sinh JWT
    const token = jwt.sign(
      {
        userId: user.id,
        username: user.username,
        roles: roles,
      },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES }
    );

    res.json({
      access_token: token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        roles: roles,
      },
    });
  } catch (err) {
    console.error("Login error:", err);
    res.status(500).json({ message: "Server error" });
  }
};
