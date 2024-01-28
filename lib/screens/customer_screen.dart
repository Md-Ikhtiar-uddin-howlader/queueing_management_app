import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Screen'),
      ),
      body: Center(
        child: Text('Welcome, Customer!'),
      ),
    );
  }
}
