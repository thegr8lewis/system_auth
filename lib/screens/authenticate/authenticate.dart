import 'package:flutter/material.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/authenticate/sign_in.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class Authenticate extends StatelessWidget {
  const Authenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const SignIn(),
      ),
    );
  }
}

    