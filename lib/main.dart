import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:queueing_management_app/screens/customer_screen.dart'; // Import the CustomerScreen
import 'package:queueing_management_app/screens/counter_screen.dart'; // Import the CustomerScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queue Management App',
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/counter': (context) => CounterScreen(),
        '/customer': (context) => CustomerScreen(userUid: ''),
      },
    );
  }
}
