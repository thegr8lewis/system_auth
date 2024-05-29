import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:system_auth/screens/authenticate/log_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _isSignUpButtonEnabled = false;
  bool _isLoading = false; // Add this line

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validateForm() {
    setState(() {
      _isSignUpButtonEnabled = _emailController.text.contains('@') &&
          _passwordController.text.length >= 6 &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true; // Show the loader
    });

    final String username = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://cities-massive-surfing-collectables.trycloudflare.com/register'), // Adjust the URL as needed
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );

    setState(() {
      _isLoading = false; // Hide the loader
    });

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign Up Failed'),
            content: const Text('Failed to create account. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  // Lottie.network(
                  //   'https://lottie.host/b3398fd6-7d87-4f2d-9823-6f0c8a659591/d86LTtBMnG.json',
                  //   height: 200,
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    'SIGN UP',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the details to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Email',
                      hintText: 'xyz123@mail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_outlined : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_outlined : Icons.visibility_off,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isSignUpButtonEnabled ? _signUp : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Sign up'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Scaffold(
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.teal,
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
