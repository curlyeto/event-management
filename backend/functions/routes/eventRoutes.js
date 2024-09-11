const express = require('express');
const { bucket } = require('../firebase'); // Import from firebase.js
const { Readable } = require('stream');

const { createEvent, getAllEvents, getEventById,deleteEventById,updateEvent,uploadImageAndUpdateEvent } = require('../controller/eventController');
const router = express.Router();
// Set up multer to handle image uploads




// Upload image to storage and update event
router.post('/events/uploadFile', uploadImageAndUpdateEvent);

// Route to create a new event
router.post('/events', createEvent);

// Route to get all events
router.get('/events', getAllEvents);

// Route to get an event by ID
router.get('/events/:id', getEventById);

router.put('/events/:id', updateEvent);


router.delete('/events/:id', deleteEventById);



// router.post('/upload', (req, res) => {
    

//     const file = req.files[0];
//     console.log(file); // you can see the file fields here, lots of good info from the parser

//     // convert the file buffer to a filestream
//     const fileStream = Readable.from(file.buffer);
    
//     // upload to firebase storage
//     const fileUpload = bucket.file("/test/"+file.originalname);

//     // create writestream with the contentType of the incoming file
//     const writeStream = fileUpload.createWriteStream({
//         metadata: {
//             contentType: file.mimetype
//         }
//     });
    
//     // pipe the filestream to be written to storage
//     fileStream.pipe(writeStream) 
//       .on('error', (error) => {
//         console.error('Error:', error);
//       })
//       .on('finish', () => {
//           console.log('File upload complete');
//       });
// });

module.exports = router;