const express = require('express');

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




module.exports = router;