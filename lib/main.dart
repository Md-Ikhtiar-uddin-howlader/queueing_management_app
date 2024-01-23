import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queuing Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement logic to issue and call numbers
            context.read<QueueManager>().callNextNumber();
          },
          child: Text('Call Number'),
        ),
      ),
    );
  }
}

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScannerScreen()),
            );
          },
          child: Text('Get Number'),
        ),
      ),
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey();
  Barcode result = Barcode('', BarcodeFormat.unknown); // Initialize with a default value
  late QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    result = scanData ??
                        Barcode('', BarcodeFormat.unknown); // Set default value if scanData is null
                    context.read<QueueManager>().addCustomer(result.code ?? '');
                  });
                });
              },
            ),
          ),
          Text('Scanned Result: ${result.code ?? "None"}'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}



class QueueManager with ChangeNotifier {
  List<Customer> _queue = [];

  List<Customer> get queue => _queue;

  void addCustomer(String customerId) {
    _queue.add(Customer(customerId, DateTime.now()));
    notifyListeners();
  }

  void callNextNumber() {
    if (_queue.isNotEmpty) {
      // Implement logic to handle calling the next number
      _queue.removeAt(0);
      notifyListeners();
    }
  }
}

class Customer {
  final String id;
  final DateTime timestamp;

  Customer(this.id, this.timestamp);
}
