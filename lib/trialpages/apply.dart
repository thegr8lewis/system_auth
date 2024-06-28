import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:system_auth/config.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _PamelaState();
}

class _PamelaState extends State<Homepage> {
  int _selectedIndex = 0;
  late Future<List<Subject>> _subjectsFuture;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
    NotificationsScreen(),
  ];

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
        Uri.parse('$BASE_URL/subjects'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        return body.map((dynamic item) => Subject.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load subjects. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching subjects: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F2),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF6200EE),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 23, 21, 178),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👋 Hi Pamela,',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                      Text(
                        'Great to see you again!',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 19,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 42.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatSection(),
              const SizedBox(height: 20),
              _buildCourseSection(context),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 76, 171, 225),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSingleStatCard('0', 'Points Earned', Colors.orange),
              // _buildSingleStatCard('32', 'Questions Done', Colors.orangeAccent),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSingleStatCard(String value, String label, Color color) {
    String imagePath = 'assets/star.gif'; // Default static image

    // Use different image paths based on the label or any other identifier
    if (label == 'Exp. Points') {
      imagePath =
          'assets/star.gif'; // Replace with your static image for Exp. Points
    } else if (label == 'Questions Done') {
      imagePath =
          'assets/soma1.png'; // Replace with your static image for Ranking
    }

    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 32,
          height: 32,
          color: color,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCourseSection(BuildContext context) {
    return FutureBuilder<List<Subject>>(
      future: _PamelaState()._fetchSubjects(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No subjects available.'));
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Practice More'),
              _buildDailyQuizCard(),
              const SizedBox(height: 20),
              _buildSectionTitle('Subjects'),
              _buildSubjectsList(snapshot.data!, context),
            ],
          );
        }
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.brown,
      ),
    );
  }

  Widget _buildDailyQuizCard() {
    double quizProgress = 0.6; // Replace with actual progress value

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Quiz',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Predictable Questions',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          CircularPercentIndicator(
            radius: 45.0,
            lineWidth: 12.0,
            animation: true,
            percent: quizProgress,
            center: Text(
              '${(quizProgress * 100).toInt()}%',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            progressColor: Colors.yellow,
            backgroundColor: Colors.white,
            circularStrokeCap: CircularStrokeCap.round,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList(List<Subject> subjects, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return GestureDetector(
          onTap: () {
            // Add your onTap logic here
          },
          child: Card(
            child: ListTile(
              title: Text(subject.name),
              subtitle: Text(subject.description),
            ),
          ),
        );
      },
    );
  }
}

class Subject {
  final String name;
  final String description;

  Subject({required this.name, required this.description});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      description: json['description'],
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications Page'),
      ),
    );
  }
}
