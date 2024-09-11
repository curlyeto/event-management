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
class DetailEventViewModel extends ChangeNotifier{
  DetailEventViewModel();
  bool? _flag=true;
  String? _firstHalfText;
  String? _secondHalfText;



  bool? get flag => _flag;
  String? get firstHalfText => _firstHalfText;
  String? get secondHalfText => _secondHalfText;


  set flag(bool? value) {
    _flag = value;
    notifyListeners();
  }
  set firstHalfText(String? value) {
    _firstHalfText = value;

  }

  set secondHalfText(String? value) {
    _secondHalfText = value;

  }
  void descriptionText(String desc){
    if (desc.length > 100) {
      firstHalfText = desc.substring(0, 100);
      secondHalfText = desc.substring(100, desc.length);
    } else {
      firstHalfText = desc;
      secondHalfText = "";
    }
  }
}