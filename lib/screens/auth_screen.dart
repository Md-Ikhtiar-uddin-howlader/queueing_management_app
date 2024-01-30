import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  final bool counter;

  AuthScreen({required this.counter});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String userUid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Enter Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
  onPressed: () async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    await FirebaseAuth.instance.signOut();

    try {
      // Fetch user data based on username
      QuerySnapshot userSnapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userEmail = userSnapshot.docs.first['email'];

        // Sign in with Firebase Authentication using email and password
        UserCredential userCredential = await FirebaseAuth
            .instance
            .signInWithEmailAndPassword(
          email: userEmail,
          password: password,
        );

        userUid = userCredential.user!.uid;
        String userRole = userSnapshot.docs.first['userRole'];

        // Check if the userRole matches the expected role based on AuthScreen's counter property
        if ((widget.counter && userRole == 'counter') ||
            (!widget.counter && userRole == 'customer')) {
          // Navigate to the appropriate screen based on the user's role
          if (userRole == 'counter') {
            Navigator.pushNamed(context, '/counter');
          } else if (userRole == 'customer') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerScreen(userUid: userUid),
              ),
            );
          }
        } else {
          // Incorrect user role, handle accordingly
          print('Incorrect user role');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Incorrect user role'),
            ),
          );
          await FirebaseAuth.instance.signOut();
        }
      } else {
        // Username not found, handle accordingly
        print('Username not found');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username not found'),
          ),
        );
      }
    } catch (e) {
      // Handle authentication errors
      print('Authentication error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect password'),
        ),
      );
    }
  },
  child: Text('Sign In'),
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
    passwordController.dispose(); // Dispose of the password controller as well
    super.dispose();
  }
}
