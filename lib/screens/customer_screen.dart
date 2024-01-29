import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr_scanner_page.dart';
import 'dynamic_qr_scanner_page.dart';

class CustomerScreen extends StatefulWidget {
  final String userUid;

  CustomerScreen({required this.userUid});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displaying the user's queue number
              StreamBuilder(
                stream: _firestore
                    .collection('Queue')
                    .where('userid', isEqualTo: widget.userUid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  }

                  if (userSnapshot.data == null ||
                      userSnapshot.data!.docs.isEmpty) {
                    // If no entries found, show a message and a button to join the queue
                    return Column(
                      children: [
                        Text(
                          'You are not in the queue',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    );
                  }

                  int userQueueNumber = userSnapshot.data!.docs.first['queue'];
                  bool isUserTurn =
                      userSnapshot.data!.docs.first['status'] == 'current';

                  return Column(
                    children: [
                      if (isUserTurn)
                        Text(
                          'It\'s your turn now!',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      SizedBox(height: 20.0),
                      Text(
                        'Your Queue Number',
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '$userQueueNumber',
                        style: TextStyle(fontSize: 100.0),
                      ),
                    ],
                  );
                },
              ),

              // Displaying the current queue number
              StreamBuilder(
                stream: _firestore
                    .collection('Queue')
                    .where('status', isEqualTo: 'current')
                    .snapshots(),
                builder: (context, currentSnapshot) {
                  if (currentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (currentSnapshot.hasError) {
                    return Text('Error: ${currentSnapshot.error}');
                  }

                  List<QueryDocumentSnapshot> currentQueueDocs =
                      currentSnapshot.data?.docs ?? [];

                  if (currentQueueDocs.isEmpty) {
                    // If no entries found, show a message and a button to join the queue
                    return Column(
                      children: [
                        Text(
                          'No current queue',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRScannerPage()),
                            );
                          },
                          child: Text('Join Queue using QR'),
                        ),
                      ],
                    );
                  }

                  int currentQueueNumber = currentQueueDocs.first['queue'];

                  return Column(
                    children: [
                      Text(
                        'Current Queue Number: $currentQueueNumber',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRScannerPage()),
                          );
                        },
                        child: Text('Scan QR Code to Join Queue'),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DynamicQRScannerPage()),
                          );
                        },
                        child: Text('Scan QR Code Issued by Counter'),
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
