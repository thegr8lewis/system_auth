// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:system_auth/screens/home/profile/userprofile.dart';
//
// class Subject {
//   final String name;
//   final String icon;
//   final int quizzes;
//
//   Subject({required this.name, required this.icon, required this.quizzes});
//
//   factory Subject.fromJson(Map<String, dynamic> json) {
//     return Subject(
//       name: json['name'],
//       icon: json['icon'],
//       quizzes: json['quizzes'],
//     );
//   }
// }
//
// class ApiService {
//   final String apiUrl = "http://your-flask-api-url/subjects";
//
//   Future<List<Subject>> fetchSubjects() async {
//     final response = await http.get(Uri.parse(apiUrl));
//
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((subject) => Subject.fromJson(subject)).toList();
//     } else {
//       throw Exception('Failed to fetch subjects');
//     }
//   }
// }
//
// class Home extends StatelessWidget {
//   const Home({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         backgroundColor: Colors.brown[400],
//         actions: [
//           TextButton(
//             child: const Text('OK', style: TextStyle(color: Colors.white)),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const UserProfile()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: HomeBody(),
//     );
//   }
// }
//
// class HomeBody extends StatefulWidget {
//   @override
//   _HomeBodyState createState() => _HomeBodyState();
// }
//
// class _HomeBodyState extends State<HomeBody> {
//   late Future<List<Subject>> futureSubjects;
//
//   @override
//   void initState() {
//     super.initState();
//     futureSubjects = ApiService().fetchSubjects();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Subject>>(
//       future: futureSubjects,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Failed to fetch subjects. Please try again later.'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No subjects found'));
//         } else {
//           return GridView.builder(
//             padding: EdgeInsets.all(16.0),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16.0,
//               mainAxisSpacing: 16.0,
//               childAspectRatio: 3 / 2,
//             ),
//             itemCount: snapshot.data!.length,
//             itemBuilder: (context, index) {
//               final subject = snapshot.data![index];
//               return GestureDetector(
//                 onTap: () {
//                   // Handle subject tap
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(16.0),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.network(subject.icon, height: 50),
//                       SizedBox(height: 10),
//                       Text(
//                         subject.name,
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                       Text('${subject.quizzes} Quizzes'),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:system_auth/screens/home/profile/userprofile.dart';
import 'package:system_auth/screens/home/mathpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOMA APP',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const Home(),
    );
  }
}

class Subject {
  final String name;
  final double progress;

  Subject({required this.name, required this.progress});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      progress: (json['progress'] as num).toDouble(),
    );
  }
}

class ApiService {
  final String apiUrl = "http://your-flask-api-url/subjects";
  final bool useMockData = true;

  Future<List<Subject>> fetchSubjects() async {
    if (useMockData) {
      // Mock data for testing
      List<Map<String, dynamic>> mockData = [
        {'name': 'Math', 'progress': 0.75},
        {'name': 'Sports', 'progress': 0.50},
        {'name': 'Music', 'progress': 0.85},
        {'name': 'Science', 'progress': 0.60},
        {'name': 'Art', 'progress': 0.40},
        {'name': 'Travel', 'progress': 0.95},
        {'name': 'History', 'progress': 0.30},
        {'name': 'Home Science', 'progress': 0.40},
        {'name': 'Computer', 'progress': 0.95},
        {'name': 'Kiswahili', 'progress': 0.30},
        {'name': 'French', 'progress': 0.40},
        {'name': 'German', 'progress': 0.95},
        {'name': 'Spanish', 'progress': 0.30},
        {'name': 'Tech', 'progress': 0.80},
      ];
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return mockData.map((subject) => Subject.fromJson(subject)).toList();
    } else {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((subject) => Subject.fromJson(subject)).toList();
      } else {
        throw Exception('Failedd to fetch subjects');
      }
    }
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: AppBar(
            title: const Text(
              'SOMA APP',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: IconButton(
                  icon: const Icon(Icons.person, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserProfile()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: const HomeBody(),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late Future<List<Subject>> futureSubjects;

  @override
  void initState() {
    super.initState();
    futureSubjects = ApiService().fetchSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Subject>>(
      future: futureSubjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to fetch subjects. Please try again later.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subjects found'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 3 / 2,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final subject = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  if (subject.name == 'Math') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MathTopicsScreen()),
                    );
                  }
                  // Handle other subject taps if needed
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          subject.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                value: subject.progress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  subject.progress > 0.8
                                      ? Colors.green
                                      : subject.progress > 0.5
                                      ? Colors.blue
                                      : Colors.red,
                                ),
                              ),
                            ),
                            Text(
                              '${(subject.progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
