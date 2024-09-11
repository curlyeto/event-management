import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/service/event_base.dart';
import 'package:frontend/core/service/event_service.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/views/utils/const.dart';
import 'package:frontend/views/utils/toast_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
class EditEventViewModel extends ChangeNotifier{
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  TextEditingController eventTypeController = TextEditingController();
  final EventService _eventService = getIt<EventService>();
  DateTime? _chooseDate;
  DateTime? _selectedDate;
  String? _imagePath;
  File? _image;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool? _submitProcess=false;



  EditEventViewModel();


  DateTime? get chooseDate => _chooseDate;
  DateTime? get selectedDate => _selectedDate;
  String? get imagePath => _imagePath!;
  File? get image => _image;
  bool? get submitProcess => _submitProcess;

  set image(File? value) {
    _image = value;
    notifyListeners();
  }
  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }
  set chooseDate(DateTime? value) {
    _chooseDate = value;
    notifyListeners();
  }
  set selectedDate(DateTime? value){
    _selectedDate = value;
  }
  set submitProcess(bool? value) {
    _submitProcess = value;
    notifyListeners();
  }


  Future<Response?> editEvent(Event defaultEvent)async{
    String date=chooseDate==null?selectedDate.toString():chooseDate.toString();
    Event event=Event(id:defaultEvent.id,title: titleController.text,description: descriptionController.text,date: date,location: locationController.text,
        organizer: organizerController.text,eventType: eventTypeController.text,imageUrl: defaultEvent.imageUrl!);
    return await _eventService.editEvent(event);
  }

  Future<Response?> uploadImage(String imagePath,String eventId)async{
    return await _eventService.uploadImage(imagePath,eventId);
  }


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
  Future submitEvent(BuildContext context,Event event) async {
    if (formKey.currentState!.validate()) {
      submitProcess=true;
      var eventResponse = await editEvent(event);
      if (eventResponse!.statusCode == 202) {
        if (image != null) {
          var imageResponse = await uploadImage(
              imagePath!, event.id.toString());
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
    }
  }


}