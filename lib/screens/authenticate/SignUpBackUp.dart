// import 'package:flutter/material.dart';
// import 'package:system_auth/screens/authenticate/log_in.dart';
// import 'package:lottie/lottie.dart';
//
// class SignIn extends StatefulWidget {
//   const SignIn({super.key});
//
//   @override
//   State<SignIn> createState() => _SignInState();
// }
//
// class _SignInState extends State<SignIn> {
//   bool _obscureText = true;
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'SOMA APP',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//
//
//               const SizedBox(height: 50),
//               Lottie.network(
//                 'https://lottie.host/b3398fd6-7d87-4f2d-9823-6f0c8a659591/d86LTtBMnG.json',
//                 height: 200,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'SIGN UP',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Enter the details to continue',
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),
//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.person),
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.email),
//                   labelText: 'Email',
//                   hintText: 'xyz123@mail.com',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   prefixIcon: const Icon(Icons.lock),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility_outlined : Icons.visibility_off,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.teal,
//                   padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Sign up'),
//               ),
//               const SizedBox(height: 20),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LogIn()),
//                   );
//                 },
//                 child: const Text('Login'),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
