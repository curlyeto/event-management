import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/service/event_base.dart';
import 'package:frontend/core/service/event_service.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/views/utils/toast_message.dart';
import 'package:image_picker/image_picker.dart';
enum ListEventViewState { Idle, Loaded, Busy }
class ListEventViewModel extends ChangeNotifier{
  ListEventViewState _state = ListEventViewState.Idle;
  final EventService _eventService = getIt<EventService>();
  List<Event>? _eventList=[];
  List<Event>? _filterList=[];
  String? _selectedEventType;
  List<String>? _eventTypes=[];
  DateTime? _selectedDate;
  DateTime? _chooseDate;
  String? _imagePath;
  File? _image;
  bool? _submitProcess=false;
  bool? _filterActive=false;

  File? get image => _image;
  bool? get filterActive => _filterActive;
  set filterActive(bool? value) {
    _filterActive = value;
    notifyListeners();
  }
  set image(File? value) {
    _image = value;
    notifyListeners();
  }


  ListEventViewModel() {
    _eventService.getAllEvents().listen((list) {
      _eventList = list;
      _eventTypes = _eventList!.map((e) => e.eventType!).toSet().toList();
      _eventTypes!.add("All");
      applyFilter();
    });
  }

  ListEventViewState get state => _state;
  List<Event>? get eventList => _selectedEventType == 'All' || _selectedEventType == null ? _eventList : _filterList;
  List<Event>? get filterList => _filterList;
  List<String> get eventTypes => _eventTypes ?? [];
  String? get selectedEventType => _selectedEventType;
  DateTime? get selectedDate => _selectedDate;
  DateTime? get chooseDate => _chooseDate;
  String? get imagePath => _imagePath!;
  bool? get submitProcess => _submitProcess;

  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  set state(ListEventViewState value) {
    _state = value;
    notifyListeners();
  }

  set selectedEventType(String? value) {
    _selectedEventType = value;
    applyFilter();
  }
  set selectedDate(DateTime? value) {
    _selectedDate = value;
    applyFilter();
  }
  set chooseDate(DateTime? value) {
    _chooseDate = value;
    notifyListeners();
  }
  set submitProcess(bool? value) {
    _submitProcess = value;
    notifyListeners();
  }


  void applyFilter() {
    _filterList = _eventList; // Start with all events

    // Apply type filter
    if (_selectedEventType != null && _selectedEventType != 'All') {
      _filterList = _filterList!.where((event) => event.eventType == _selectedEventType).toList();
    }

    // Apply date filter
    if (_selectedDate != null) {

      _filterList = _filterList!.where((event) =>
      DateTime.parse(event.date!).year == _selectedDate!.year &&
          DateTime.parse(event.date!).month == _selectedDate!.month &&
          DateTime.parse(event.date!).day == _selectedDate!.day).toList();

    }
    if(_selectedEventType == 'All'){
      _filterList=_eventList;
      _filterActive= ! _filterActive!;
      _selectedDate=null;
    }

    notifyListeners();
  }




  Future<Response?> createEvent(Event event)async{
    return await _eventService.createEvent(event);
  }

  Future<Response?> uploadImage(String imagePath,String eventId)async{
    return await _eventService.uploadImage(imagePath,eventId);
  }
  Future<Response?> deleteEvent(String eventId)async{
    return await _eventService.deleteEvent(eventId);
  }



  void takePhotoFromCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    var _selectedImage = await picker.pickImage(source: ImageSource.camera);

    imagePath=_selectedImage!.path;
    image = File(_selectedImage.path);
    Navigator.of(context).pop();
  }
  void selectPhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    var _yeniResim = await picker.pickImage(source: ImageSource.gallery);

    imagePath=_yeniResim!.path;
    image = File(_yeniResim.path);
    Navigator.of(context).pop();
  }

  void deleteEventButton(BuildContext context,String eventId) async{
    submitProcess=true;
    Response? response=await deleteEvent(eventId);
    if(response!.statusCode==200){
      submitProcess=false;
      ToastMessage.successToast(
          title: response.data['message'].toString());
      Navigator.pop(context);
    }else{
      submitProcess=false;
      ToastMessage.errorToast(
          title: response.data['error'].toString());
    }
  }
  Future<void> showDateDialog(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate=picked;
      filterActive=  !(filterActive!);
    }
  }


}