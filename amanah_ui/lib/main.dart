import 'package:flutter/material.dart';
import 'screens/checkout_screen.dart';

void main() {
  runApp(const AmanahBotApp());
}

class AmanahBotApp extends StatelessWidget {
  const AmanahBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amanah-Bot EaaS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CheckoutScreen(),
    );
  }
}
