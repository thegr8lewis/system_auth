import 'package:flutter/material.dart';
import 'package:system_auth/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget
    return const Authenticate();
  }
}