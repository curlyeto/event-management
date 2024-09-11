import 'package:flutter/material.dart';
import 'package:frontend/core/viewmodel/event/create_event_view_model.dart';
import 'package:frontend/core/viewmodel/event/detail_event_view_model.dart';
import 'package:frontend/core/viewmodel/event/edit_event_view_model.dart';
import 'package:frontend/core/viewmodel/event/list_event_view_model.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/views/pages/list_event_page.dart';
import 'package:frontend/views/utils/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListEventViewModel>(create: (_) => ListEventViewModel()),
        ChangeNotifierProvider<CreateEventViewModel>(create: (_) => CreateEventViewModel()),
        ChangeNotifierProvider<EditEventViewModel>(create: (_) => EditEventViewModel()),
        ChangeNotifierProvider<DetailEventViewModel>(create: (_) => DetailEventViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ListEventPage(),
      ),
    );
  }
}
