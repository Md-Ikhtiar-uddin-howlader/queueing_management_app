import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueueQRPage extends StatefulWidget {
  @override
  _QueueQRPageState createState() => _QueueQRPageState();
}

class _QueueQRPageState extends State<QueueQRPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Code to Join Queue'),
        ),
        body: FutureBuilder<int>(
          future: _getLatestQueueNumber(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('Error: Unable to generate QR code.'));
            }

            int latestQueueNumber = snapshot.data!;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Scan this code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  QrImageView(
                    data: "Queue Number: $latestQueueNumber",
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<int> _getLatestQueueNumber() async {
    try {
      QuerySnapshot latestQueueSnapshot = await _firestore
          .collection('Queue')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (latestQueueSnapshot.docs.isNotEmpty) {
        int latestQueueNumber = latestQueueSnapshot.docs.first['queue'];
        print('Latest queue number: $latestQueueNumber');
        return latestQueueNumber + 1;
      } else {
        print('No queue number found.');
        return 1; // Default value if no queue number is found (you may adjust this based on your requirements)
      }
    } catch (error) {
      print('Error fetching latest queue number: $error');
      return 0; // Default value in case of an error
    }
  }
}
