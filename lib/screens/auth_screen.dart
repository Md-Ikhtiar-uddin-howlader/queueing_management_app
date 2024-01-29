import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'counter_screen.dart';
import 'customer_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController usernameController = TextEditingController();
  String userUid = ''; // Add this line to store user UID

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

                  // Navigate to the appropriate screen based on the user's role
                  if (userRole == 'counter') {
                    Navigator.pushNamed(context, '/counter');
                  } else if (userRole == 'customer') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerScreen(userUid: userUid),
                      ),
                    );
                  } else {
                    Navigator.pushNamed(context, '/home');
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
