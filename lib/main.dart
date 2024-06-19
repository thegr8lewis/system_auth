import 'package:flutter/material.dart';
import 'package:system_auth/screens/authenticate/grade.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/home/home.dart';
import 'package:system_auth/screens/home/profile/userprofile.dart';
import 'package:system_auth/screens/subjecsui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LogIn(), // Set initial screen here
    );
  }
}
