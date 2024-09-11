import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/service/event_base.dart';
import 'package:dio/dio.dart';
class EventService implements EventBase{
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;
  final dio=Dio();
  final String baseUrl="https://us-central1-event-management-ea467.cloudfunctions.net/api";
  @override
  Stream<List<Event>>  getAllEvents() {
    return _firebaseDB.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  @override
  Future<Response?> createEvent(Event event) async{
    try {
      var response = await dio.post(
        "$baseUrl/events",
        data: event.toJson(),
      );

      return response;
    } catch (e) {
      debugPrint("Error sending event: $e");
      return null;
    }

  }

  @override
  Future<Response?> uploadImage(String imagePath, String eventId) async{
    try {
      String fileName=imagePath.split("/").last;
      final formData = FormData.fromMap({
        "files": imagePath==""?null:await MultipartFile.fromFile(imagePath, filename:fileName),
        'eventId':eventId
      });

      var response = await dio.post(
        "$baseUrl/events/uploadFile",
        data: formData,
      );
      return response;
    } catch (e) {
      debugPrint("Error sending event: $e");
      return null;
    }
  }

  @override
  Future<Response?> editEvent(Event event) async{
    try {

      var response = await dio.put(
        "$baseUrl/events/${event.id}",
        data: event.toJson(),
      );

      return response;
    } catch (e) {
      debugPrint("Error sending event: $e");
      return null;
    }
  }

  @override
  Future<Response?> deleteEvent(String eventId) async{
    try {
      var response = await dio.delete(
        "$baseUrl/events/${eventId}"
      );
      return response;
    } catch (e) {
      debugPrint("Error sending event: $e");
      return null;
    }
  }

}