class BaseModel {
    constructor(collection) {
      this.collection = collection;
    }
  
    async create(data) {
      const timestamp = new Date().toISOString();
      const docRef = await this.collection.add({
        ...data,
        createdAt: timestamp,
        updatedAt: timestamp,
        imageUrl:"https://timelyapp-prod.s3.us-west-2.amazonaws.com/images/21269328/every%20brilliant%20thing_ilq0.jpg"
      });
      return { id: docRef.id, ...data };
    }
  
    async findById(id) {
      const docRef = await this.collection.doc(id).get();
      if (!docRef.exists) {
        throw new Error('Document not found');
      }
      return { id: docRef.id, ...docRef.data() };
    }
  
    async findAll() {
      const snapshot = await this.collection.get();
      return snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    }
  
    async update(id, data) {
      const timestamp = new Date().toISOString();
      await this.collection.doc(id).set({
        ...data,
        updatedAt: timestamp
      }, { merge: true });
      return { id, ...data, updatedAt: timestamp };
    }
  
    async delete(id) {
      await this.collection.doc(id).delete();
      return { id };
    }
  }
  
  module.exports = BaseModel;