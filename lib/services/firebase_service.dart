import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:queueing_management_app/main.dart';

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
    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print('Firebase Messaging Token: $token');
    });

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/customer',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessage.listen(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
