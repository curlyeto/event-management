const BaseModel = require("./baseModel");
const { db } = require('../firebase');
class Event extends BaseModel{
  constructor() {
    super(db.collection('events')); 
  }
  
}
  
  module.exports = new Event();