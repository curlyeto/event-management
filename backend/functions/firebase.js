// firebase.js
const admin = require('firebase-admin');
const serviceAccount = require('./event-management-ea467-firebase-adminsdk-4rewt-8e89add026.json'); // Go up one directory

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'event-management-ea467.appspot.com',
});

const db = admin.firestore();
const bucket = admin.storage().bucket();


module.exports = { admin, db,bucket };