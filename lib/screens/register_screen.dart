import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
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
                String userRole = 'customer';

                try {
                  // Create user with Firebase Authentication
                  UserCredential userCredential =
                      await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Create a document in the 'users' collection with the user UID
                  await _firestore
                      .collection('users')
                      .doc(userCredential.user!.uid)
                      .set({
                    'username': username,
                    'email': email,
                    'userRole': userRole,
                  });
                  Navigator.pushReplacementNamed(context, '/home');
                } catch (e) {
                  print('Error during registration: $e');
                }
              },
              child: Text('Register'),
            ),
          ],
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
