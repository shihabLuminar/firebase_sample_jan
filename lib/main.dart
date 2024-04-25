import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sample_jan/view/home_screen/home_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBXnmJYudtG_xsToCIcCtWx8hBiPCD8MhE",
          appId: "1:1025777796893:android:3c8ff11fea40dd0df903f4",
          messagingSenderId: "",
          projectId: "dec-sample",
          storageBucket: "dec-sample.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
