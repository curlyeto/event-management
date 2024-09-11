import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/viewmodel/event/edit_event_view_model.dart';
import 'package:frontend/core/viewmodel/event/list_event_view_model.dart';
import 'package:frontend/views/utils/app_functions.dart';
import 'package:frontend/views/utils/color.dart';
import 'package:frontend/views/utils/const.dart';
import 'package:frontend/views/widget/custom_text.dart';
import 'package:frontend/views/widget/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  const EditEventPage({super.key, required this.event});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EditEventViewModel viewModel=context.read<EditEventViewModel>();
    viewModel.titleController.text=widget.event.title!;
    viewModel.descriptionController.text=widget.event.description!;
    viewModel.locationController.text=widget.event.location!;
    viewModel.organizerController.text=widget.event.organizer!;
    viewModel.eventTypeController.text=widget.event.eventType!;
    viewModel.selectedDate=DateTime.parse(widget.event.date!);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
            color: Colors.white
        ),
        title: const CustomText(
          "Edit Event",
          color: AppColors.whiteColor,
          fontSize: 20,
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Consumer<EditEventViewModel>(
        builder: (context,viewModel,child){


          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Form(
                  key: viewModel.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText("Upload Image (Optinal)",weight: FontWeight.bold,)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Center(
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(48), // Image radius
                              child: viewModel.image != null?Image.file(viewModel.image!, fit: BoxFit.cover):
                              Image.network( widget.event.imageUrl! ?? AppConstant.defaultImageUrl,fit: BoxFit.cover,),
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
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: CustomText("Date",weight: FontWeight.bold)),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        GestureDetector(
                          onTap: () =>viewModel.showDateTimePicker(context: context,initialDate: viewModel.chooseDate),
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
                                CustomText(viewModel.chooseDate ==null?AppFunctions.dateTimeFormat(viewModel.selectedDate!):AppFunctions.dateTimeFormat(viewModel.chooseDate!)),


                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        ElevatedButton(
                          onPressed: () =>viewModel.submitProcess! ?null:viewModel.submitEvent(context,widget.event),
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
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      )

      ,
    );
  }


}
