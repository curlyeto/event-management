const { db } = require('../firebase');
const Event = require('../model/eventModel');
const { bucket } = require('../firebase');
const { Readable } = require('stream');
const logger = require("firebase-functions/logger");



// Upload storage and update firesotre document
const uploadImageAndUpdateEvent = async (req, res) => {
  if (!req.files || req.files.length === 0) {
      await Event.delete(req.body.eventId);
      return res.status(400).json({ message: 'No file uploaded.', eventId: req.body.eventId });
  }

    const file = req.files[0];
    const buffer = file.buffer; 
    const fileSizeMB = buffer.length / (1024 * 1024); 

    if (fileSizeMB > 5) {
        return res.status(400).json({ message: 'File size exceeds 5MB limit.', eventId: req.body.eventId });
    }

  const filePath = `events/${file.originalname}`; 

  const fileUpload = bucket.file(filePath);
  try {
      const [exists] = await fileUpload.exists();
      let publicUrl;

      if (!exists) {
          const fileStream = Readable.from(file.buffer);
          await new Promise((resolve, reject) => {
              const writeStream = fileUpload.createWriteStream({
                  metadata: { contentType: file.mimetype }
              });
              fileStream.pipe(writeStream).on('finish', async () => {
                  await fileUpload.makePublic();
                  resolve();
              }).on('error', reject);
          });
          publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;
      } else {
          publicUrl = `https://storage.googleapis.com/${bucket.name}/${filePath}`;
      }

      // Update the event document with the image URL
      await db.collection('events').doc(req.body.eventId).update({
          imageUrl: publicUrl
      });

      res.status(200).json({ message: 'Event updated successfully', imageUrl: publicUrl, eventId: req.body.eventId });
  } catch (error) {
      await Event.delete(req.body.eventId);
      console.error('Error checking file existence and updating event:', error);
      res.status(500).json({ error: 'Failed to check file or update event', eventId: req.body.eventId });
  }
};
const createEvent = async (req, res) => {
  try {
    const eventData = req.body;
  
    const newEvent = await Event.create(eventData);  // Call create on the Event instance
    res.status(201).json({ message: 'Event created successfully', id: newEvent.id });
  } catch (error) {
    console.error('Error creating event:', error);
    res.status(500).json({ error: 'Failed to create event' });
  }
};

// Get all events
const getAllEvents = async (req, res) => {
  try {
    const events = await Event.findAll();
    res.status(200).json(events);
  } catch (error) {
    console.error('Error fetching events:', error);
    res.status(500).json({ error: 'Failed to fetch events' });
  }
};

// Get event by ID
const getEventById = async (req, res) => {
  try {
    const { id } = req.params;
    const event = await Event.findById(id);
    res.status(200).json(event);
  } catch (error) {
    console.error('Error fetching event by ID:', error);
    res.status(500).json({ error: 'Failed to fetch event' });
  }
};
const updateEvent = async (req, res) => {
  try {
    const { id } = req.params;
    const updatedData = req.body;
    const updatedEvent = await Event.update(id, updatedData);
    res.status(202).json({ message: 'Event updated successfully', updatedEvent });
  } catch (error) {
    console.error('Error updating event:', error);
    res.status(500).json({ error: 'Failed to update event' });
  }
};


// Get event by ID
const deleteEventById = async (req, res) => {
  try {
    const { id } = req.params;
    await Event.delete(id);
    res.status(200).json({ message: 'Event deleted successfully' });
  } catch (error) {
    console.error('Error fetching event by ID:', error);
    res.status(500).json({ error: 'Failed to fetch event' });
  }
};

module.exports = { createEvent, getAllEvents, getEventById,deleteEventById,updateEvent,uploadImageAndUpdateEvent };