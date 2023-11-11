// index.js
require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");

// Firebase
const admin = require("firebase-admin");
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Verify Firebase token and get the user ID
const getFirebaseUserId = async (idToken) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    return decodedToken.uid; // This UID should correspond to `firebase_uid` in DB
  } catch (error) {
    console.error("Error verifying Firebase token:", error);
    throw error;
  }
};

const app = express();
const port = process.env.PORT || 3000;
const connectionString = process.env.DB_URL;

const pool = new Pool({
  connectionString: connectionString,
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
    const result = await pool.query(
      "SELECT facts.* FROM facts INNER JOIN topics ON facts.topic_id = topics.topic_id WHERE topics.topic_name = $1;",
      [topic]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Server error");
  }
});

app.post('/facts/:factId/upvote', async (req, res) => {
  const { factId } = req.params;
  const userUid = req.user.uid; // Assuming req.user.uid is set after authentication

  try {
    // Insert the upvote record into the users_upvoted table
    const result = await pool.query(`
      INSERT INTO users_upvoted (user_id, fact_id)
      SELECT u.user_id, $1 FROM users u WHERE u.firebase_uid = $2
      ON CONFLICT (user_id, fact_id) DO NOTHING;
    `, [factId, userUid]);

    if (result.rowCount === 0) {
      return res.status(409).send('Fact already upvoted by the user.');
    }

    res.status(200).send('Fact upvoted successfully.');
  } catch (error) {
    console.error('Error upvoting fact:', error);
    res.status(500).send('Internal server error.');
  }
});

app.post('/facts/:factId/downvote', async (req, res) => {
  const { factId } = req.params;
  const userUid = req.user.uid; // Assuming req.user.uid is set after authentication

  try {
    // Insert the downvote record into the users_downvoted table
    const result = await pool.query(`
      INSERT INTO users_downvoted (user_id, fact_id)
      SELECT u.user_id, $1 FROM users u WHERE u.firebase_uid = $2
      ON CONFLICT (user_id, fact_id) DO NOTHING;
    `, [factId, userUid]);

    if (result.rowCount === 0) {
      return res.status(409).send('Fact already downvoted by the user.');
    }

    res.status(200).send('Fact downvoted successfully.');
  } catch (error) {
    console.error('Error downvoting fact:', error);
    res.status(500).send('Internal server error.');
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

app.post("/users/topics", async (req, res) => {
  const { idToken, topic_id } = req.body; // Expect the Firebase ID token and topic ID in the request body

  try {
    // Verify the ID token and get the firebase_uid
    const firebase_uid = await getFirebaseUserId(idToken);

    // Get the user_id from the users table using firebase_uid
    const userResult = await pool.query(
      "SELECT user_id FROM users WHERE firebase_uid = $1",
      [firebase_uid]
    );
    if (userResult.rowCount === 0) {
      return res.status(404).send("User not found.");
    }
    const user_id = userResult.rows[0].user_id;

    // Check if the topic exists
    const topicExists = await pool.query(
      "SELECT 1 FROM topics WHERE topic_id = $1",
      [topic_id]
    );
    if (topicExists.rowCount === 0) {
      return res.status(404).send("Topic not found.");
    }

    // Check if the association already exists
    const existingAssociation = await pool.query(
      "SELECT 1 FROM users_topics WHERE user_id = $1 AND topic_id = $2",
      [user_id, topic_id]
    );
    if (existingAssociation.rowCount > 0) {
      return res.status(409).send("User already associated with this topic.");
    }

    // Insert the user_id and topic_id into the users_topics table
    const insertResult = await pool.query(
      "INSERT INTO users_topics (user_id, topic_id) VALUES ($1, $2)",
      [user_id, topic_id]
    );

    // Respond with success message
    res.status(201).send("Topic associated with user successfully.");
  } catch (err) {
    console.error(err);
    if (err.code === "auth/id-token-revoked") {
      res.status(401).send("Firebase ID token has been revoked.");
    } else if (err.code === "auth/id-token-expired") {
      res.status(401).send("Firebase ID token has expired.");
    } else {
      res.status(500).send("Internal server error.");
    }
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
