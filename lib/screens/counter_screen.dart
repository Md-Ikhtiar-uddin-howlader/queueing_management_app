import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'queue_qr_page.dart'; // Import your QR page file
import 'package:firebase_messaging/firebase_messaging.dart';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int currentQueueNumber = 0; // Set initial value to 0

  // Function to call the next incomplete number and mark it as 'current'
  Future<void> _callNextNumber() async {
    try {
      // Retrieve the next incomplete queue entry based on timestamp
      QuerySnapshot incompleteQueueSnapshot = await _firestore
          .collection('Queue')
          .where('status', isEqualTo: 'incomplete')
          .orderBy('timestamp')
          .limit(1)
          .get();

      if (incompleteQueueSnapshot.docs.isNotEmpty) {
        // ... (Your existing code)

        // Retrieve customer's FCM token
        String customerUid = incompleteQueueSnapshot.docs.first['userid'];
        DocumentSnapshot customerSnapshot =
            await _firestore.collection('users').doc(customerUid).get();
        String? customerFcmToken = customerSnapshot['fcmToken'];

        // Send push notification
        /*await FirebaseMessaging.instance.send(
          RemoteMessage(
            data: {
              'title': 'Your Turn!',
              'body': 'It\'s your turn now. Please proceed to the counter.',
            },
            to: customerFcmToken,
          ),
        );*/
      } else {
        // No incomplete queue entry found.
        print('No incomplete queue entry found.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No queue available.'),
          ),
        );
      }
    } catch (error) {
      print('Error calling the next incomplete number: $error');
    }
  }

  // Function to navigate to the QR page
  void _navigateToQRPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QueueQRPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              StreamBuilder(
                stream: _firestore.collection('Queue').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  List<QueryDocumentSnapshot> queueDocuments =
                      snapshot.data!.docs;

                  // Filter documents with status 'current'
                  List<QueryDocumentSnapshot> currentQueueDocuments =
                      queueDocuments
                          .where((doc) => doc['status'] == 'current')
                          .toList();

                  // Sort by timestamp if needed
                  currentQueueDocuments
                      .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

                  if (currentQueueDocuments.isEmpty) {
                    // No 'current' queue entry found, keep showing the last known queue number
                    return Column(
                      children: [
                        Text(
                          'Current Queue Number',
                        ),
                        Text(
                          '$currentQueueNumber',
                          style: TextStyle(fontSize: 100.0),
                        ),
                        if (queueDocuments
                            .any((doc) => doc['status'] == 'incomplete'))
                          ElevatedButton(
                            onPressed: () {
                              _callNextNumber();
                            },
                            child: Text('Call Next Number'),
                          )
                        else
                          ElevatedButton(
                            onPressed: null, // Button is disabled
                            child: Text('No Incomplete Queue'),
                          ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: _navigateToQRPage,
                          child: Text('Issue New Queue Number'),
                        ),
                      ],
                    );
                  }

                  currentQueueNumber = currentQueueDocuments.first['queue'];

                  return Column(
                    children: [
                      Text(
                        'Current Queue Number',
                      ),
                      Text(
                        '$currentQueueNumber',
                        style: TextStyle(fontSize: 100.0),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _callNextNumber();
                        },
                        child: Text('Call Next Number'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _navigateToQRPage,
                        child: Text('Issue New Queue Number'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
