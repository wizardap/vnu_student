import 'package:flutter/material.dart';
import 'package:vnu_student/features/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vnu_student/firebase_options.dart';


void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
    );
  }
}