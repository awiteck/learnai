// index.js
require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");

// Firebase
var admin = require("firebase-admin");
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();
const port = process.env.PORT || 3000;
const connectionString = process.env.DATABASE_URL;

const pool = new Pool({
  connectionString: process.env.DB_URL,
});

app.use(express.json());

// Test endpoint to verify that the server is running
app.get("/", (req, res) => {
  res.json({ message: "Welcome to the API server" });
});

// Get facts for a specific topic
app.get("/facts/:topic", async (req, res) => {
  try {
    const { topic } = req.params;
    const result = await pool.query("SELECT * FROM facts WHERE topic = $1", [
      topic,
    ]);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
});

app.post("/register", async (req, res) => {
  const { email, password } = req.body;

  try {
    // Create user with Firebase Authentication
    const userRecord = await admin.auth().createUser({
      email,
      password,
    });

    // Insert new user into PostgreSQL users table
    const queryResult = await pool.query(
      "INSERT INTO users(firebase_uid, email) VALUES($1, $2) RETURNING id",
      [userRecord.uid, email]
    );

    // Respond with the created user's ID from your database
    res.status(201).json({ userId: queryResult.rows[0].id });
  } catch (err) {
    console.error(err);
    if (err.code === "auth/email-already-exists") {
      res.status(400).send("Email already exists.");
    } else {
      res.status(500).send("Internal server error.");
    }
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
