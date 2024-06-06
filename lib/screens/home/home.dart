import 'package:flutter/material.dart';
import 'package:system_auth/screens/home/profile/userprofile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.brown[400],
        actions: [
          TextButton(
            child: const Text('OK', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
        ],
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
