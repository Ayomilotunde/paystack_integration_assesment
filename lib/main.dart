import 'package:flutter/material.dart';
import 'package:paystack_integration_assesment/screens/checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paystack Integrations Assessment',
      theme: ThemeData.light(),
      home: const PaymentCheckOutPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
