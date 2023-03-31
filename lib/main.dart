import 'package:first_app/Reminder.dart';
import 'package:first_app/screens/splashScreen.dart';
import 'package:first_app/utils/app_style.dart';
import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedBay',
      theme: ThemeData(
        primaryColor: primary ,
      ),
      home: SplashScreen(),

    );
  }
}

