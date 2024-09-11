// firebase.js
const admin = require('firebase-admin');
const serviceAccount = require('./event-management-4cb70-4639599109a6.json'); // Go up one directory

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'event-management-4cb70.appspot.com',
});

const db = admin.firestore();
const bucket = admin.storage().bucket();

module.exports = { admin, db,bucket };