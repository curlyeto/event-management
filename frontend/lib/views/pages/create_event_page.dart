import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/viewmodel/event/create_event_view_model.dart';
import 'package:frontend/core/viewmodel/event/list_event_view_model.dart';
import 'package:frontend/views/utils/app_functions.dart';
import 'package:frontend/views/utils/color.dart';
import 'package:frontend/views/utils/const.dart';
import 'package:frontend/views/utils/toast_message.dart';
import 'package:frontend/views/widget/custom_text.dart';
import 'package:frontend/views/widget/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
            color: Colors.white
        ),
        title: const CustomText(
          "Create Event",
          color: AppColors.whiteColor,
          fontSize: 20,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Consumer<CreateEventViewModel>(
        builder: (BuildContext context, CreateEventViewModel viewModel, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Form(
                  key: viewModel.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText("Upload Image (Optinal)",weight: FontWeight.bold,),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Center(
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: viewModel.image !=null?
                              Image.file(viewModel.image!, fit: BoxFit.cover):
                              Image.network(AppConstant.defaultImageUrl,fit: BoxFit.cover,),
                            ),
                          ),
                        ),

                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (modalContext) {
                                      return Container(
                                        height: 160,
                                        child: Column(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(Icons.camera),
                                              title: CustomText("Take a photo"),
                                              onTap: () {
                                               viewModel.takePhotoFromCamera(modalContext,context);
                                              },
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.image),
                                              title: CustomText("Select image"),
                                              onTap: () {
                                                viewModel.selectPhoto(modalContext,context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: AppColors.primaryColor),
                              child: const CustomText("Upload Image",color: Colors.white)),
                        ),

                        CustomTextField(
                          labelText: "Title",
                          width: MediaQuery.of(context).size.width,
                          controller: viewModel.titleController,
                          keyBoardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title';
                            }
                            return null;
                          },
                          hintText: "Enter Title",
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        CustomTextField(
                          labelText: "Description",
                          width: MediaQuery.of(context).size.width,
                          controller: viewModel.descriptionController,
                          keyBoardType: TextInputType.text,
                          hintText: "Enter Description",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                          maxLines: 4,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        CustomTextField(
                          labelText: "Location",
                          width: MediaQuery.of(context).size.width,
                          controller: viewModel.locationController,
                          keyBoardType: TextInputType.text,
                          hintText: "Enter Location",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location';
                            }
                            return null;
                          },

                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        CustomTextField(
                          labelText: "Organizer",
                          width: MediaQuery.of(context).size.width,
                          controller: viewModel.organizerController,
                          keyBoardType: TextInputType.text,
                          hintText: "Enter Organizer",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter organizer';
                            }
                            return null;
                          },

                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        CustomTextField(
                          labelText: "Event Type",
                          width: MediaQuery.of(context).size.width,
                          controller: viewModel.eventTypeController,
                          keyBoardType: TextInputType.text,
                          hintText: "Enter Event Type",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter event type';
                            }
                            return null;
                          },

                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        const Align(
                            alignment:Alignment.centerLeft,
                            child: CustomText("Date",weight:FontWeight.bold)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () =>viewModel.showDateTimePicker(context: context),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColors.textFieldBorderColor)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.05,
                                ),
                                CustomText(viewModel.chooseDate ==null?"Select Date":AppFunctions.dateTimeFormat(viewModel.chooseDate!)),
                              ],
                            ),
                          ),
                        ),
                        viewModel.selectedDateError! ?
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                          child: const CustomText("Please select date",color: Color(0xFFCD5A5E),fontSize: 12,weight: FontWeight.w500),
                        )
                            :Container(),



                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: ()=> viewModel.submitProcess! ?null:viewModel.submitEvent(context),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: AppColors.primaryColor),
                            child: viewModel.submitProcess! ?
                            const CircularProgressIndicator(color: Colors.white,)
                                : const CustomText(
                              "Submit",
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },

      ),
    );
  }

}

