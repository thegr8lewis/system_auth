import 'package:flutter/material.dart';
import 'package:system_auth/screens/authenticate/grade.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/authenticate/sign_in.dart';
import 'package:system_auth/screens/home/home.dart';
import 'package:system_auth/screens/home/profile/profilebackup.dart';
import 'package:system_auth/screens/home/profile/userprofile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:system_auth/screens/home/profile/profilebackup.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide userId and sessionToken
    // // Consider using a state management solution to handle authentication
    // String userId = 'someUserId';
    // String sessionToken = 'someSessionToken';
    return   const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}
