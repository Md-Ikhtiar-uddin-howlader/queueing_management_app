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
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Firebase Cloud Firestore
  Future<void> addCustomerToQueue(
      String customerId, String customerName) async {
    try {
      await _firestore.collection('queue').doc(customerId).set({
        'name': customerName,
        'queueNumber':
            FieldValue.serverTimestamp(), // Add your queue number logic here
      });
    } catch (e) {
      print('Error adding customer to queue: $e');
    }
  }

  // Firebase Cloud Messaging
  Future<void> sendPushNotification(String customerId, String message) async {
    try {
      await _firebaseMessaging.subscribeToTopic(customerId);
      await _firebaseMessaging.sendMessage(
        to: '/topics/$customerId',
        data: <String, String>{
          'title': 'Queue Update',
          'body': message,
        },
      );
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  // Other Firebase-related methods can be added based on your app's requirements
}
