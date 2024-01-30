import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isQueueJoined = false; // Flag to track whether the queue has been joined

  // Use a fixed customer ID for demonstration purposes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ], // <- Close the Column here
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // Extract the QR code data from the Barcode instance
      String barcodeData = scanData.code ?? '';

      // Print the raw scanned data
      print('Raw Scanned Data: $barcodeData');

      // Handle the scanned data
      if (barcodeData.trim().toLowerCase() == 'join queue' && !isQueueJoined) {
        // If the scanned data is 'join queue' and the queue is not already joined
        _joinQueue();
        isQueueJoined =
            true; // Set the flag to true to prevent multiple executions
      }
      if (barcodeData.trim().toLowerCase() != 'join queue') {
        controller.pauseCamera();
        _showSnackbar('Wrong QR Code');
        Navigator.pop(context);
      }
    });
  }

  Future<void> _joinQueue() async {
    try {
      // Check if the user is authenticated
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use the UID as the customer ID
        String customerUid = user.uid;

        // Check the current queue size
        QuerySnapshot currentQueueSnapshot =
            await FirebaseFirestore.instance.collection('Queue').get();

        int currentQueueSize = currentQueueSnapshot.size;

        // Check if the queue has reached the maximum limit (e.g., 100)
        if (currentQueueSize >= 100) {
          _showSnackbar('The queue is full. Please try again later.');
          return;
        }

        // Check if the user is already in the queue with status "incomplete" or "current"
        QuerySnapshot existingQueueSnapshot = await FirebaseFirestore.instance
            .collection('Queue')
            .where('userid', isEqualTo: customerUid)
            .where('status', whereIn: ['incomplete', 'current']).get();

        if (existingQueueSnapshot.docs.isNotEmpty) {
          _showSnackbar('You are already in the queue.');
          Navigator.pop(context);
          return;
        }

        // Retrieve the last value of the "queue" field
        QuerySnapshot lastQueueSnapshot = await FirebaseFirestore.instance
            .collection('Queue')
            .orderBy('queue', descending: true)
            .limit(1)
            .get();

        int lastQueueValue = 1; // Default value if no documents are present

        if (lastQueueSnapshot.docs.isNotEmpty) {
          lastQueueValue = lastQueueSnapshot.docs.first['queue'] + 1;
        }

        // Get the current timestamp
        Timestamp currentTime = Timestamp.now();

        // Add a new document with the incremented "queue" value, timestamp, and other information
        await FirebaseFirestore.instance.collection('Queue').add({
          'queue': lastQueueValue,
          'userid': customerUid, // Use the UID as the customer ID
          'status': 'incomplete', // Set an initial status, adjust as needed
          'timestamp': currentTime,
        });

        _showSnackbar('Successfully joined the queue. Wait for your turn.');

        // Close the QR scanner page and go back to the previous screen
        Navigator.pop(context);
        // TODO: Implement notifications for customers when their turn comes
      } else {
        // User not authenticated, handle accordingly
        _showSnackbar('Error: User not authenticated.');
      }
    } catch (error) {
      print('Error joining queue: $error');
      _showSnackbar('Error joining the queue. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
