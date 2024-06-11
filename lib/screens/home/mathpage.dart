import 'package:flutter/material.dart';

class MathTopicsScreen extends StatelessWidget {
  final List<String> mathTopics = [
    "Linear Equations",
    "Quadratic Equations",
    "Polynomials",
    "Factorization",
    "Inequalities",
    "Functions and Graphs",
    "Exponents and Logarithms",
    "Linear Equations",
    "Quadratic Equations",
    "Polynomials",
    "Factorization",
    "Inequalities",
    "Functions and Graphs",
    "Exponents and Logarithms",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Topics'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.grey[200], // Background color of the screen
        child: ListView.builder(
          itemCount: mathTopics.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // Different color from the background
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                mathTopics[index],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }
}
