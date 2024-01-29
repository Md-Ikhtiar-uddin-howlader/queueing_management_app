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
}
  // Firebase Cloud Messaging
 /* Future<void> sendPushNotification(String customerId, String message) async {
    await _firebaseMessaging.subscribeToTopic(customerId);
    await _firebaseMessaging.send(
      Message(
        data: {
          'title': 'Queue Update',
          'body': message,
        },
        topic: customerId,
      ),
    );
  }

  // Other Firebase-related methods can be added based on your app's requirements
*/
