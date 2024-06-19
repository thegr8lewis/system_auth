import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SubjectsScreen(),
    );
  }
}

class SubjectsScreen extends StatelessWidget {
  final List<Subject> subjects = [
    Subject('Mathematics Grade 3', 0.1),
    Subject('English Grade 3', 0.5),
    Subject('Social Studies Grade 3', 0.2),
    Subject('Science Grade 3', 0.1),
    Subject('Mathematics Grade 3', 0.1),
    Subject('English Grade 3', 0.5),
    Subject('Social Studies Grade 3', 0.2),
    Subject('Science Grade 3', 0.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Subjects'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FutureBuilder<String>(
                    future: _loadAnimation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('Loading...');
                      } else if (snapshot.hasError) {
                        return const Text('Error loading animation');
                      } else {
                        return snapshot.hasData
                            ? Lottie.network(
                          snapshot.data!,
                          height: 150,
                        )
                            : const Text('No animation data');
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  // child: Text(
                  //   'Welcome back',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return SubjectCard(subject: subject);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _loadAnimation() async {
    // Simulate loading the animation URL
    await Future.delayed(const Duration(seconds: 2)); // Replace with actual loading logic
    return 'https://lottie.host/b3398fd6-7d87-4f2d-9823-6f0c8a659591/d86LTtBMnG.json';
  }
}

class Subject {
  final String name;
  final double progress;

  Subject(this.name, this.progress);
}

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subject.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 5,  // Adjust the height to change the thickness of the progress bar
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: subject.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Text(
              '${(subject.progress * 100).toInt()}%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


