import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_auth/screens/home/home.dart';
import '../../config.dart';

void main() {
  runApp(const MaterialApp(
    home: GradePage(),
  ));
}

class GradePage extends StatefulWidget {
  const GradePage({Key? key}) : super(key: key);

  @override
  State<GradePage> createState() => _GradePageState();
}

class _GradePageState extends State<GradePage> {
  int? _currentGrade;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> sendDataToDatabase(int? grade) async {
    final sessionCookie = await _storage.read(key: 'session_cookie');

    final url = Uri.parse('$BASE_URL/grade');
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    try {
      final sessionCookie = await _storage.read(key: 'session_cookie');
      if (sessionCookie == null) {
        // Handle not logged in scenario (optional)
        print('User not logged in');
        return;
      }

      headers['Cookie'] = sessionCookie;

      var body = jsonEncode({
        'grade': grade,
      });

      var response = await http.put(url, headers: headers, body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Successful request
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Grade updated successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Handle other status codes
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Failed to set grade'),
            content: const Text('There was an error setting the grade. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error sending grade: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Network Error'),
          content: const Text('Please check your network connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Grade'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(9, (index) => GradeOption(
                grade: index + 1,
                currentGrade: _currentGrade,
                onChanged: (value) {
                  setState(() {
                    _currentGrade = value;
                  });
                  sendDataToDatabase(value); // Update database on grade change
                },
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class GradeOption extends StatelessWidget {
  final int grade;
  final int? currentGrade;
  final ValueChanged<int?> onChanged;

  const GradeOption({
    required this.grade,
    required this.currentGrade,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<int?>(
            value: grade,
            groupValue: currentGrade,
            onChanged: onChanged,
          ),
          Text('Grade $grade'),
        ],
      ),
    );
  }
}
