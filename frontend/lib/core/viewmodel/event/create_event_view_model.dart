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
import 'package:panara_dialogs/panara_dialogs.dart';
class CreateEventViewModel extends ChangeNotifier{
  final EventService _eventService = getIt<EventService>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  DateTime? _chooseDate;
  String? _imagePath;
  File? _image;
  bool? _selectedDateError=false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? _submitProcess=false;




  CreateEventViewModel();

  DateTime? get chooseDate => _chooseDate;
  String? get imagePath => _imagePath!;
  File? get image => _image;
  bool? get selectedDateError => _selectedDateError;
  bool? get submitProcess => _submitProcess;


  set chooseDate(DateTime? value) {
    _chooseDate = value;
    notifyListeners();
  }
  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }
  set image(File? value) {
    _image = value;
    notifyListeners();
  }
  set selectedDateError(bool? value) {
    _selectedDateError = value;
    notifyListeners();
  }
  set submitProcess(bool? value) {
    _submitProcess = value;
    notifyListeners();
  }

  /// Service Methods
  Future<Response?> createEvent()async{
    Event event=Event(id: '',title: titleController.text,description: descriptionController.text,date: chooseDate.toString(),location: locationController.text,
        organizer: organizerController.text,eventType: eventTypeController.text,updatedAt: "");
    return await _eventService.createEvent(event);
  }

  Future<Response?> uploadImage(String imagePath,String eventId)async{
    return await _eventService.uploadImage(imagePath,eventId);
  }

 /// View Methods
  void takePhotoFromCamera(BuildContext context,BuildContext dialogContext) async {
    final ImagePicker picker = ImagePicker();

    var _selectedImage = await picker.pickImage(source: ImageSource.camera);
    if(_selectedImage !=null){
      final File imageFile = File(_selectedImage.path);
      final int fileSize = await imageFile!.length();
      if (fileSize <= 5 * 1024 * 1024) {
        imagePath = _selectedImage.path;
        image = imageFile;
        Navigator.of(context).pop();
      }else{
        Navigator.of(context).pop();
        PanaraInfoDialog.show(
          dialogContext,
          title: 'File Too Large',
          message: 'Please select a file smaller than 5MB.',
          panaraDialogType: PanaraDialogType.error,
          barrierDismissible: false,
          buttonText: 'OK', onTapDismiss: () {
          Navigator.of(dialogContext).pop();
        },
        );

      }
    }


  }
  void selectPhoto(BuildContext context,BuildContext dialogContext) async {
    final ImagePicker picker = ImagePicker();
    var _selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if(_selectedImage !=null){
      final File imageFile = File(_selectedImage.path);
      final int fileSize = await imageFile!.length();
      if (fileSize <= 5 * 1024 * 1024) {
        imagePath = _selectedImage.path;
        image = imageFile;
        Navigator.of(context).pop();
      }else{
        Navigator.of(context).pop();
        PanaraInfoDialog.show(
          dialogContext,
          title: 'File Too Large',
          message: 'Please select a file smaller than 5MB.',
          panaraDialogType: PanaraDialogType.error,
          barrierDismissible: false,
          buttonText: 'OK', onTapDismiss: () {
          Navigator.of(dialogContext).pop();
        },
        );

      }
    }

  }
  void showDateTimePicker({required BuildContext context, DateTime? initialDate, DateTime? firstDate, DateTime? lastDate,}) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;


    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

   chooseDate= selectedTime == null
        ? selectedDate
        : DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  Future submitEvent(BuildContext context) async {
    if (formKey.currentState!.validate() && chooseDate != null) {
      submitProcess=true;
      var eventResponse = await createEvent();
      if (eventResponse!.statusCode == 201) {
        if (image != null) {
          var imageResponse = await uploadImage(
              imagePath!, eventResponse.data['id'].toString());
          if (imageResponse!.statusCode == 200) {
            image = null;
            imagePath = null;
            submitProcess=false;
            ToastMessage.successToast(
                title: eventResponse.data['message'].toString());
            Navigator.pop(context);
          } else {
            submitProcess=false;
            ToastMessage.errorToast(
                title: eventResponse.data['error'].toString());
          }
        } else {
          submitProcess=false;
          ToastMessage.successToast(
              title: eventResponse.data['message'].toString());
          Navigator.pop(context);
        }
      } else {
        submitProcess=false;
        ToastMessage.successToast(
            title: eventResponse.data['message'].toString());
      }
    } else {
      selectedDateError = true;
      return;
    }
  }
}