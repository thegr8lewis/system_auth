import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:system_auth/screens/home/questions.dart';

import '../../config.dart';

class TopicsPage extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  TopicsPage({required this.subjectId, required this.subjectName});

  @override
  _TopicsPageState createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  List topics = [];

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  fetchTopics() async {
    final response = await http.get(Uri.parse('$BASE_URL/${widget.subjectId}/topics'));
    if (response.statusCode == 200) {
      setState(() {
        topics = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName} Topics'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(topics[index]['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionsPage(
                    topicId: topics[index]['id'],
                    topicName: topics[index]['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}