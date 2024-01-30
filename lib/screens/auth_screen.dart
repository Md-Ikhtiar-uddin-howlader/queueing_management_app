import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'counter_screen.dart';
import 'customer_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool counter;

  AuthScreen({required this.counter});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  String userUid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Enter Username'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String username = usernameController.text.trim();

                // Check if the entered username exists in the 'users' collection
                QuerySnapshot userSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: username)
                    .limit(1)
                    .get();

                if (userSnapshot.docs.isNotEmpty) {
                  userUid = userSnapshot.docs.first.id;
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
                    } else {
                      Navigator.pushNamed(context, '/home');
                    }
                  } else {
                    // Incorrect user role, handle accordingly
                    print('Incorrect user role');
                  }
                } else {
                  // Username not found, handle accordingly
                  print('Username not found');
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}
