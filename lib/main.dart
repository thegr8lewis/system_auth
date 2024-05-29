import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? accessToken = await storage.read(key: 'access_token');

  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String? accessToken;

  const MyApp({Key? key, this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: accessToken != null ? const Home() : const LogIn(),
    );
  }
}
