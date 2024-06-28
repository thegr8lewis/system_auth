import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_auth/screens/authenticate/grade.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/home/home.dart';
import 'package:system_auth/screens/home/profile/userprofile.dart';
import 'package:system_auth/screens/onboarding/onboarding_page.dart';
import 'package:system_auth/screens/onboarding/splashscreen.dart';
import 'package:system_auth/themes/theme_provider.dart';
import 'package:system_auth/trialpages/apply.dart';
import 'package:system_auth/trialpages/trial2.dart';
import 'package:system_auth/trialpages/trial3.dart';
import 'package:system_auth/trialpages/trial4.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      // home: SplashScreen(), // Set initial screen here
      home: SplashScreen(),
    );
  }
}
