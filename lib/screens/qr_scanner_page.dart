import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'customer_screen.dart'; // Import the CustomerScreen

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isQueueJoined = false; // Flag to track whether the queue has been joined

  // Use a fixed customer ID for demonstration purposes
  final String fixedCustomerId = '1';

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
    controller.scannedDataStream.listen((scanData) {
      // Extract the QR code data from the Barcode instance
      String barcodeData =
          scanData.code ?? ''; // Provide an empty string as a default

      // Handle the scanned data
      if (barcodeData.toLowerCase().trim() == 'join queue' && !isQueueJoined) {
        _joinQueue(fixedCustomerId);
        isQueueJoined =
            true; // Set the flag to true to prevent multiple executions
      } else {
        print('Incorrect QR code. Try again. Scanned data: $barcodeData');
        controller.pauseCamera();
      }
    });
  }

  Future<void> _joinQueue(String customerId) async {
    try {
      // Check the current queue size
      QuerySnapshot currentQueueSnapshot =
          await FirebaseFirestore.instance.collection('Queue').get();

      int currentQueueSize = currentQueueSnapshot.size;

      // Check if the queue has reached the maximum limit (e.g., 100)
      if (currentQueueSize >= 100) {
        _showSnackbar('The queue is full. Please try again later.');
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
        'userid': customerId,
        'status': 'incomplete', // Set an initial status, adjust as needed
        'timestamp': currentTime,
      });

      _showSnackbar('Successfully joined the queue. Wait for your turn.');

      // Close the QR scanner page and go back to the previous screen
      Navigator.pop(context);
      // TODO: Implement notifications for customers when their turn comes
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
