import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Firebase Authentication
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Firebase Cloud Firestore
  Future<void> addCustomerToQueue(
      String customerId, String customerName) async {
    await _firestore.collection('queue').doc(customerId).set({
      'name': customerName,
      'queueNumber':
          FieldValue.serverTimestamp(), // Add your queue number logic here
    });
  }

  Future<void> initFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission(
      sound: true,
      badge: true,
      alert: true,
    );
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.body}');
      // Handle foreground messages here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.notification?.body}');
      // Handle messages that were received while the app was in the background and opened by the user
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.notification?.body}');
    // Handle background messages here
  }
}
