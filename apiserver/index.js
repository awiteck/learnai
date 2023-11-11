// index.js
require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3000;

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
    const result = await pool.query("SELECT facts.* FROM facts INNER JOIN topics ON facts.topic_id = topics.topic_id WHERE topics.topic_name = $1;",
    [
      topic,
    ]);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
});




// User Registration
app.post("/register", async (req, res) => {
  const { email, firebase_uid } = req.body;

  try {
    // Insert new user into PostgreSQL users table
    const queryResult = await pool.query(
      "INSERT INTO users(firebase_uid, email) VALUES($1, $2) RETURNING id",
      [firebase_uid, email]
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
