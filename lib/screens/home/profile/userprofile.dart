import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:system_auth/screens/home/home.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _name;
  String? _profileImageUrl;
  int? _grade;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _updateErrorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final sessionCookie = await _storage.read(key: 'session_cookie');
      final response = await http.get(
        Uri.parse('https://hearings-critics-start-deemed.trycloudflare.com/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': sessionCookie ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _name = data['username'];
          _profileImageUrl = data['profile_image_url'];
          _grade = data['grade'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = 'Failed to load user data';
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = 'Error fetching user data';
      });
    }
  }

  Future<void> _updateProfile(String newName, int newGrade) async {
    final sessionCookie = await _storage.read(key: 'session_cookie');
    final response = await http.put(
      Uri.parse('https://hearings-critics-start-deemed.trycloudflare.com/update'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': sessionCookie ?? '',
      },
      body: jsonEncode(<String, dynamic>{
        'username': newName,
        'grade': newGrade,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _name = newName;
        _grade = newGrade;
        _updateErrorMessage = '';
      });
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserProfile()),
      );
    } else {
      setState(() {
        _updateErrorMessage = 'Failed to update';
      });
    }
  }

  Future<void> _deleteProfile() async {
    final sessionCookie = await _storage.read(key: 'session_cookie');
    final response = await http.delete(
      Uri.parse('https://hearings-critics-start-deemed.trycloudflare.com/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionCookie ?? '',
      },
    );

    if (response.statusCode == 200) {
      // Profile successfully deleted, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } else {
      setState(() {
        _updateErrorMessage = 'Failed to delete Profile';
      });
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: const Text('Are you sure you want to delete your profile? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteProfile();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog() {
    final TextEditingController nameController = TextEditingController(text: _name);
    final TextEditingController gradeController = TextEditingController(text: _grade?.toString());
    bool isUpdating = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  title: const Text('Update Your Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: gradeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.school),
                          hintText: 'GRADE',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      if (_updateErrorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _updateErrorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: nameController.text.isNotEmpty && gradeController.text.isNotEmpty && !isUpdating
                          ? () async {
                        setState(() {
                          isUpdating = true;
                        });
                        await _updateProfile(nameController.text, int.parse(gradeController.text));
                        setState(() {
                          isUpdating = false;
                        });
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isUpdating)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.teal,
                        size: 100,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            if (_hasError)
              Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                child: _profileImageUrl != null
                    ? Text(
                  _name?.substring(0, 2).toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                _name ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Text(
                    _grade != null ? 'Grade: $_grade' : 'Loading...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (_updateErrorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _updateErrorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showUpdateDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showDeleteConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
