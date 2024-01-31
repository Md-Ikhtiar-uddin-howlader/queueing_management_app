import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'screens/customer_screen.dart'; // Import the CustomerScreen
import 'screens/counter_screen.dart'; // Import the CustomerScreen

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseService().initFirebaseMessaging();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
