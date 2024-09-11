class Event{
  final String? id;
  final String? title;
  final String? description;
  final String? date;
  final String? location;
  final String? organizer;
  final String? imageUrl;
  final String? eventType;
  final String? updatedAt;

  Event({
    this.id,
    this.title,
    this.description,
    this.date,
    this.location,
    this.organizer,
    this.imageUrl,
    this.eventType,
    this.updatedAt,
  });

  factory Event.fromFirestore(Map<String, dynamic> firestoreData, String documentId) {
    return Event(
      id: documentId,
      title: firestoreData['title'],
      description: firestoreData['description'],
      date: firestoreData['date'], // Assuming 'date' is a Timestamp
      location: firestoreData['location'],
      organizer: firestoreData['organizer'],
      imageUrl: firestoreData['imageUrl'],
      eventType: firestoreData['eventType'],
      updatedAt: firestoreData['updatedAt'], // Assuming 'updatedAt' is a Timestamp
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'organizer': organizer,
      'eventType': eventType,
      'imageUrl':imageUrl,
    };
  }
}