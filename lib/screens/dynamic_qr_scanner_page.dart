import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DynamicQRScannerPage extends StatefulWidget {
  @override
  _DynamicQRScannerPageState createState() => _DynamicQRScannerPageState();
}

class _DynamicQRScannerPageState extends State<DynamicQRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool isQueueJoined = false;

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
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      String qrData = scanData.code ?? '';
      print('Scanned QR Code: $qrData'); // Print for testing

      if (!isQueueJoined) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userUid = user.uid;
          print('Current UID: $userUid'); // Print current UID
          _assignQueueToUser(userUid, qrData);
          isQueueJoined = true;
        } else {
          print('User not authenticated');
        }
      }
    });
  }

  Future<void> _assignQueueToUser(String customerId, String queueData) async {
    try {
      controller.pauseCamera();

      // Extract numeric part from the QR code data
      String numericPart = queueData.replaceAll(RegExp(r'[^0-9]'), '');
      int parsedQueueNumber = int.parse(numericPart);

      // Check if a document with the same queue number already exists
      QuerySnapshot existingQueueSnapshot = await FirebaseFirestore.instance
          .collection('Queue')
          .where('queue', isEqualTo: parsedQueueNumber)
          .get();

      QuerySnapshot currentQueueSnapshot =
          await FirebaseFirestore.instance.collection('Queue').get();

      int currentQueueSize = currentQueueSnapshot.size;

      // Check if the queue has reached the maximum limit (e.g., 100)
      if (currentQueueSize >= 100) {
        _showSnackbar('The queue is full. Please try again later.');
        return;
      }

      QuerySnapshot queueExistSnapshot = await FirebaseFirestore.instance
          .collection('Queue')
          .where('userid', isEqualTo: customerId)
          .where('status', whereIn: ['incomplete', 'current']).get();

      if (queueExistSnapshot.docs.isNotEmpty) {
        _showSnackbar('You are already in the queue.');
        Navigator.pop(context);
        return;
      }

      if (existingQueueSnapshot.docs.isNotEmpty) {
        // A document with the same queue number and 'incomplete' status already exists
        _showSnackbar('Queue number $parsedQueueNumber is already assigned');
        Navigator.pop(context);
      } else {
        // No document with the same queue number found, proceed to add a new document
        await FirebaseFirestore.instance.collection('Queue').add({
          'queue': parsedQueueNumber,
          'userid': customerId,
          'status': 'incomplete', // Set an initial status, adjust as needed
          'timestamp': FieldValue.serverTimestamp(),
        });

        _showSnackbar('Successfully assigned queue number $parsedQueueNumber.');

        // Reset isQueueJoined to allow scanning a new QR code
        isQueueJoined = false;
      }
    } catch (error) {
      print('Error assigning queue to user: $error');
      _showSnackbar('Error assigning the queue. Please try again.');
      Navigator.pop(context);
    } finally {
      controller.resumeCamera();
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
