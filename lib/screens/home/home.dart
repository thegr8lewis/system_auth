import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static Future<void> saveUserLoggedInSharedPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Save user logged in state as false
    Helper.saveUserLoggedInSharedPreference(false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.brown[400],
      ),
      body: const Center(
        child: Text(
          'Welcome to Soma App',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
