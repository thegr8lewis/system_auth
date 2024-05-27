import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
