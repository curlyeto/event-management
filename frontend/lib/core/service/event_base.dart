import 'package:dio/dio.dart';
import 'package:frontend/core/model/event.dart';

abstract class EventBase{
  Stream<List<Event>> getAllEvents();
  Future<Response?> createEvent(Event event);
  Future<Response?> editEvent(Event event);
  Future<Response?> uploadImage(String imagePath,String eventId);
  Future<Response?> deleteEvent(String eventId);
}