import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'counter_screen.dart';
import 'customer_screen.dart';

class AuthScreen extends StatelessWidget {
  final String userRole;

  AuthScreen({required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Placeholder for authentication logic
            await Future.delayed(Duration(seconds: 2));

            // Navigate to the appropriate screen based on the user's role
            if (userRole == 'counter') {
              Navigator.pushReplacementNamed(context, '/counter');
            } else if (userRole == 'customer') {
              Navigator.pushReplacementNamed(context, '/customer');
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: Text('Sign In as $userRole'),
        ),
      ),
    );
  }
}
