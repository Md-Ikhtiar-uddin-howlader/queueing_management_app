import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  final String userRole;

  RegisterScreen({required this.userRole});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text.trim();
                  String password = passwordController.text.trim();
                  String email = emailController.text.trim();

                  // Validate input fields
                  if (username.isEmpty) {
                    setState(() {
                      errorMessage = 'Please fill in the username.';
                    });
                    return;
                  }
                  if (password.isEmpty) {
                    setState(() {
                      errorMessage = 'Please fill in the password.';
                    });
                    return;
                  }
                  if (email.isEmpty) {
                    setState(() {
                      errorMessage = 'Please fill in the email.';
                    });
                    return;
                  }

                  try {
                    // Create user with Firebase Authentication
                    UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Create a document in the 'users' collection with the user UID and specified userRole
                    await _firestore
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'username': username,
                      'email': email,
                      'userRole': widget.userRole,
                    });

                    // Show success message
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Registration Successful'),
                        content: Text('You have successfully registered.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    // Handle registration errors
                    print('Error during registration: $e');
                    setState(() {
                      errorMessage = 'Registration failed. Please try again.';
                    });
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
