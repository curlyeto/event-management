import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/core/model/event.dart';
import 'package:frontend/core/viewmodel/event/detail_event_view_model.dart';
import 'package:frontend/views/utils/app_functions.dart';
import 'package:frontend/views/utils/color.dart';
import 'package:frontend/views/utils/const.dart';
import 'package:frontend/views/widget/custom_text.dart';
import 'package:provider/provider.dart';

class DetailEventPage extends StatefulWidget {
  final Event event;
  const DetailEventPage({super.key, required this.event});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<DetailEventViewModel>().descriptionText(widget.event.description!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          centerTitle: true,
          title: CustomText("${widget.event.title}",color: Colors.white,fontSize: 20,),
          backgroundColor: AppColors.primaryColor,
        ),
        body: Consumer<DetailEventViewModel>(
          builder: (context,viewModel,child){
            return   Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(widget.event.imageUrl!,fit: BoxFit.cover,height: 250,width: MediaQuery.of(context).size.width,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText("${widget.event.title}",fontSize: 18,weight: FontWeight.bold),
                            viewModel.secondHalfText!.isEmpty
                                ?  CustomText( viewModel.firstHalfText!)
                                : Column(
                              children: <Widget>[
                                CustomText(viewModel.flag! ? ("${viewModel.firstHalfText!}...") : (viewModel.firstHalfText! +  viewModel.secondHalfText!)),
                                InkWell(
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      CustomText(
                                        viewModel.flag! ? "show more" : "show less",
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                  onTap: () {

                                    viewModel.flag = ! viewModel.flag!;
                                  },
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                CustomText("${widget.event.location}")
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                CustomText(AppFunctions.formatDateTime(DateTime.parse(widget.event.date!)))
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                Icon(Icons.people_outline),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                CustomText("${widget.event.organizer}")
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                CustomText("${widget.event.eventType}")
                              ],
                            ),


                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            );
          },
        )


    );
  }
}
