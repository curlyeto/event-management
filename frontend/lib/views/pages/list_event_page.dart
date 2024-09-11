import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/viewmodel/event/list_event_view_model.dart';
import 'package:frontend/views/pages/create_event_page.dart';
import 'package:frontend/views/pages/detail_event_page.dart';
import 'package:frontend/views/pages/edit_event_page.dart';
import 'package:frontend/views/utils/app_functions.dart';
import 'package:frontend/views/utils/color.dart';
import 'package:frontend/views/utils/const.dart';
import 'package:frontend/views/widget/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';

class ListEventPage extends StatefulWidget {
  const ListEventPage({super.key});

  @override
  State<ListEventPage> createState() => _ListEventPageState();
}

class _ListEventPageState extends State<ListEventPage> with SingleTickerProviderStateMixin{
  SlidableController? controller;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=SlidableController(this);

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: CustomText("Event List",color: AppColors.whiteColor,fontSize: 20,),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateEventPage()),
                );

              },
              child: Icon(Icons.add,color: AppColors.whiteColor,)),
          SizedBox(width: MediaQuery.of(context).size.width*0.03,)
        ],
      ),
      body: Consumer<ListEventViewModel>(
        builder:  (context,viewModel,child){

          if (viewModel.state == ListEventViewState.Busy) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.eventList!.isEmpty) {

            print(viewModel.eventList!.length);
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(AppConstant.noDataAnimation,height: 150),
                    CustomText("No events available."),

                    viewModel.selectedDate!= null || viewModel.selectedEventType !=null?ElevatedButton(
                      onPressed: (){
                        viewModel.selectedEventType=null;
                        viewModel.selectedDate=null;
                        viewModel.filterList =[];
                        viewModel.filterActive=false;
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: AppColors.primaryColor),
                      child: const CustomText(
                        "Remove Filter",
                        color: AppColors.whiteColor,
                      ),
                    ):Container()
                  ],
            ));
          }else if ( (viewModel.filterActive! && viewModel.filterList!.isEmpty)) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(AppConstant.noDataFoundAnimation,height: 150),
                    CustomText("No events found for the selected filter."),
                    ElevatedButton(
                      onPressed: (){
                        viewModel.selectedEventType=null;
                        viewModel.selectedDate=null;
                        viewModel.filterList =[];
                        viewModel.filterActive=false;
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: AppColors.primaryColor),
                      child: const CustomText(
                        "Remove Filter",
                        color: AppColors.whiteColor,
                      ),
                    )
                  ],
                ));
          }else {
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                      flex: 1,
                      child: filterActions(context,viewModel)),
                  Expanded(
                      flex: 9,
                      child: listEvents(context,viewModel)),

                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget filterActions(BuildContext context,ListEventViewModel viewModel) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => viewModel.showDateDialog(context),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color:AppColors.borderGreyColor)
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  CustomText(viewModel.selectedDate ==null?"Select Date":AppFunctions.dateFormat(viewModel.selectedDate!)),
                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                  Icon(Icons.calendar_month)
                ],
              ),
            ),
          ),
          DropdownButton<String>(
            value: viewModel.selectedEventType,
            elevation: 16,
            hint: CustomText("Select Date"),
            onChanged: (String? value) {
              viewModel.selectedEventType = value;

            },
            items: viewModel.eventTypes!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: CustomText(value!),
              );
            }).toList(),
          )

        ],
      ),
    );
  }

  Widget listEvents(BuildContext context, ListEventViewModel viewModel,) {
    List<Event>? allEventList=[];
    if(viewModel.filterList!.isNotEmpty){
      allEventList=viewModel.filterList;
    }else{
      allEventList=viewModel.eventList;
    }

    return ListView.builder(
      itemCount: allEventList!.length,
      itemBuilder: (context, index) {
        return eventItem(context,allEventList!, index,viewModel);
      },
    );
  }
  Widget eventItem(BuildContext context,List<Event> eventList, int index, ListEventViewModel viewModel){

    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailEventPage(event: eventList[index],)),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height*0.32,
        margin: EdgeInsets.all(16),
        child: Card(
          color: AppColors.whiteColor,
          child: Slidable(
            key: ValueKey(index),
            endActionPane:  ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (slideContext){
                    PanaraConfirmDialog.show(
                      context,
                      title: "${eventList[index].title} Delete",
                      message: "Do you really want to delete ${eventList[index].title} event",
                      panaraDialogType: PanaraDialogType.normal,
                      barrierDismissible: false,
                      confirmButtonText: 'Yes',
                      cancelButtonText: 'No',
                      onTapConfirm: ()=>viewModel.submitProcess! ?null:viewModel.deleteEventButton(context,eventList[index].id!),
                      onTapCancel: () {
                        Navigator.pop(context);
                      }, // optional parameter (default is true)
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  onPressed: (context){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditEventPage(event: eventList[index],)),
                    );
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
              ],
            ),
            child: Builder(
              builder: (context){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(eventList[index].imageUrl! ?? AppConstant.defaultImageUrl,height: MediaQuery.of(context).size.height*0.2,width: MediaQuery.of(context).size.width,fit: BoxFit.cover,),
                    SizedBox(height: MediaQuery.of(context).size.width*0.01,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(eventList[index].title!,fontSize: 16,weight: FontWeight.bold,),
                              SizedBox(height: MediaQuery.of(context).size.width*0.01,),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.01,
                                  ),
                                  CustomText(eventList[index].location!),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width*0.01,),
                              Row(
                                children: [
                                  Icon(Icons.access_time,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.01,
                                  ),
                                  CustomText(AppFunctions.formatDateTime(DateTime.parse(eventList[index].date!)),fontSize: 11,),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap:(){
                                  Slidable.of(context)?.openEndActionPane();
                                },
                                child: SvgPicture.asset(AppConstant.editIcon,height: 20,),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width*0.03,),
                              Row(
                                children: [
                                  Icon(Icons.people_outline),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.01,
                                  ),
                                  CustomText(eventList[index].eventType!,fontSize: 11,),
                                ],
                              )

                            ],
                          )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }







}