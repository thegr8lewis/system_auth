import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_auth/screens/home/topics.dart';
import 'package:system_auth/screens/home/profile/userprofile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOMA APP',
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Subject>> _subjectsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _baseUrl = 'https://angle-hd-selective-sofa.trycloudflare.com';

  @override
  void initState() {
    super.initState();
    _subjectsFuture = _fetchSubjects();
  }

  Future<List<Subject>> _fetchSubjects() async {
    try {
      final sessionCookie = await _storage.read(key: 'session_cookie');
      if (sessionCookie == null) {
        throw Exception('No session cookie found');
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/subjects'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Subject.fromJson(item)).toList();
      } else {
        print('Failed to load subjects. Response body: ${response.body}');
        throw Exception('Failed to load subjects. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching subjects: $e');
      throw Exception('Error fetching subjects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('SOMA APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Subject>>(
        future: _subjectsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subjects available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var subject = snapshot.data![index];
                return ListTile(
                  title: Text(subject.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicsPage(
                          subjectId: subject.id,
                          subjectName: subject.name,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Subject {
  final int id;
  final String name;
  final int grade;

  Subject({required this.id, required this.name, required this.grade});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      grade: json['grade'],
    );
  }
}
