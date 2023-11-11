// index.js
require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3000;

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
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

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
