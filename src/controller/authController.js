// src/controllers/authController.js
const pool = require("../db/connectorDB");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { generateToken, generateRefreshToken } = require("../utils/jwt");
const JWT_SECRET = process.env.JWT_SECRET || "supersecret";
const JWT_EXPIRES = "1h"; // Access token 1h

// resgister api
exports.register = async (req, res) => {
  try {
    const { username, email, password, role } = req.body;

    // 1. Kiểm tra dữ liệu đầu vào
    if (!username || !email || !password) {
      return res.status(400).json({ message: "Vui lòng nhập đủ thông tin" });
    }

    // 2. Kiểm tra email đã tồn tại chưa
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ message: "Email đã tồn tại" });
    }

    // 3. Mã hoá mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    // 4. Tạo user mới
    const user = new User({
      username,
      email,
      password: hashedPassword,
      role: role || "employee", // mặc định là nhân viên
    });

    await user.save();

    // 5. Tạo token trả về (nếu muốn login luôn sau khi đăng ký)
    const accessToken = generateToken(user);
    const refreshToken = generateRefreshToken(user);

    res.status(201).json({
      message: "Đăng ký tài khoản thành công",
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        role: user.role,
      },
      accessToken,
      refreshToken,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Lỗi server", error: err.message });
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
