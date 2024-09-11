/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const fileParser = require('express-multipart-file-parser')
const bodyParser = require('body-parser');

const functions = require('firebase-functions');
const express = require('express');
const cors = require('cors');
const eventRoutes = require('./routes/eventRoutes');
const {db} = require('./firebase');

const app = express();


app.use(fileParser);
app.use(cors({ origin: true }));
app.use(bodyParser.urlencoded({ extended: true }));

// Use the routes
app.use('/', eventRoutes);

exports.triggerOnUpdate = functions.firestore
    .document('events/{events}')
    .onUpdate((change, context) => {
     // Get an object representing the current and previous state of the document
     const newValue = change.after.data();
     const oldValue = change.before.data();

     // Check if updatedAt already up-to-date
     const newUpdatedAt = new Date(newValue.updatedAt).getTime();
     const now = new Date().getTime();


     if (newUpdatedAt && (now - newUpdatedAt < 1000)) { 
         console.log('Skip updating to avoid loop');
         return null;
     }

     const timestamp = new Date().toISOString();

     // Update the updatedAt field in the document
     return change.after.ref.update({
         updatedAt: timestamp
     })
     .then(() => console.log('Updated the updatedAt field'))
     .catch(error => console.error('Error updating document:', error));
        
});

exports.api = functions.https.onRequest(app);



// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });