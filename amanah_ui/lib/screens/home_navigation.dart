import 'package:flutter/material.dart';
import 'checkout_screen.dart';
import 'dispute_chat_screen.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [const CheckoutScreen(), const DisputeChatScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.shield_outlined), label: 'Escrow'),
          NavigationDestination(icon: Icon(Icons.gavel_outlined), label: 'Disputes'),
        ],
      ),
    );
  }
}