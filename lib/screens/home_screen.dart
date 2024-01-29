import 'package:flutter/material.dart';
import 'package:queueing_management_app/screens/counter_screen.dart';
import 'auth_screen.dart';
import 'queue_page.dart';
import 'customer_screen.dart'; // Import the CustomerScreen
import 'register_screen.dart'; // Import the CustomerScreen
import 'customer_screen.dart';
import 'package:queueing_management_app/services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    firebaseService.initFirebaseMessaging();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CounterScreen(), // Navigate to CustomerScreen
                  ),
                );
              },
              child: Text('Go to Counter Screen'), // Add a button for testing
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthScreen(),
                  ),
                );
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterScreen(), // Navigate to CustomerScreen
                  ),
                );
              },
              child: Text('Register as Customer'), // Add a button for testing
            ),
          ],
        ),
      ),
    );
  }
}
