import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:system_auth/screens/authenticate/forgot_pass.dart';
import 'package:system_auth/screens/authenticate/sign_in.dart';
import 'package:system_auth/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  bool _obscureText = true;
  bool _rememberMe = false;
  bool _isLoading = false; // Add this line

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _checkFields() {
    _isButtonEnabled.value =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);
    _passwordController.addListener(_checkFields);
    _loadRememberMe();
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFields);
    _passwordController.removeListener(_checkFields);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadRememberMe() async {
    bool rememberMe = (await _storage.read(key: 'remember_me')) == 'true';
    if (rememberMe) {
      String? email = await _storage.read(key: 'email');
      if (email != null) {
        _emailController.text = email;
      }
    }
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Show the loader
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://cities-massive-surfing-collectables.trycloudflare.com/login'), // Adjust the URL as needed
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'remember': _rememberMe,
      }),
    );

    setState(() {
      _isLoading = false; // Hide the loader
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      if (_rememberMe) {
        await _storage.write(key: 'remember_me', value: 'true');
        await _storage.write(key: 'email', value: email);
      } else {
        await _storage.delete(key: 'remember_me');
        await _storage.delete(key: 'email');
      }

      // Navigate to the protected area of the app or show success message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password'),
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
                    'LOG IN',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your email and Password',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _isButtonEnabled,
                            builder: (context, value, child) {
                              return Switch(
                                value: _rememberMe,
                                onChanged: value
                                    ? (bool newValue) {
                                  setState(() {
                                    _rememberMe = newValue;
                                  });
                                }
                                    : null,
                                activeColor: Colors.teal,
                              );
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPass()),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isButtonEnabled,
                    builder: (context, value, child) {
                      return ElevatedButton(
                        onPressed: value ? _login : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Login'),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text('Sign up'),
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
