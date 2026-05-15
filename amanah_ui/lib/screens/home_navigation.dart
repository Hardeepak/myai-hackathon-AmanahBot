import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;
import 'checkout_screen.dart';
import 'dispute_chat_screen.dart';
import 'seller_dashboard.dart';
import 'login_screen.dart';
import '../services/demo_state.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _selectedIndex = 0;
  String? _deepLinkId;

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  void _handleDeepLink() {
    final String? id = html.window.location.href.contains('?id=') 
      ? Uri.parse(html.window.location.href).queryParameters['id'] 
      : null;
    
    if (id != null && id.isNotEmpty) {
      setState(() {
        _deepLinkId = id;
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DemoState.demoNotifier,
      builder: (context, isDemo, child) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            
            // BYPASS LOGIC: If Demo Mode is active OR Firebase is logged in
            if (!snapshot.hasData && !DemoState.isDemoMode) {
              return const LoginScreen();
            }

            return _buildMainDashboard();
          },
        );
      },
    );
  }

  Widget _buildMainDashboard() {
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? "guest";
    
    // Check for Demo Override first
    final String effectiveRole = DemoState.overrideRole ?? 
                                (email == "seller@gmail.com" ? "SELLER" : 
                                (email == "buyer@gmail.com" ? "BUYER" : "GUEST"));

    final bool isSeller = effectiveRole == "SELLER";
    final bool isBuyer = effectiveRole == "BUYER";

    List<Widget> pages = [];
    List<Map<String, dynamic>> navItems = [];

    if (isSeller) {
      pages = [const SellerDashboard()];
      navItems = [{"icon": Icons.storefront_rounded, "label": "Seller Hub"}];
    } else if (isBuyer) {
      pages = [CheckoutScreen(escrowId: _deepLinkId), const DisputeChatScreen()];
      navItems = [
        {"icon": Icons.shield_rounded, "label": "Buyer Hub"},
        {"icon": Icons.gavel_rounded, "label": "Disputes"},
      ];
    } else {
      pages = [const SellerDashboard(), CheckoutScreen(escrowId: _deepLinkId), const DisputeChatScreen()];
      navItems = [
        {"icon": Icons.storefront_rounded, "label": "Seller"},
        {"icon": Icons.shield_rounded, "label": "Buyer"},
        {"icon": Icons.gavel_rounded, "label": "Disputes"},
      ];
    }

    if (_selectedIndex >= pages.length) _selectedIndex = 0;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF3F4F6), Color(0xFFE5E7EB)],
              ),
            ),
          ),
          pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        height: 85,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...navItems.asMap().entries.map((entry) {
                      return _buildNavItem(entry.key, entry.value['icon'], entry.value['label']);
                    }).toList(),
                    _buildLogoutItem(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutItem() {
    return GestureDetector(
      onTap: () {
        DemoState.isDemoMode = false;
        DemoState.overrideRole = null;
        DemoState.demoNotifier.value = false;
        FirebaseAuth.instance.signOut();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.logout, color: const Color(0xFF1D1D1B).withOpacity(0.3), size: 26),
          const SizedBox(height: 4),
          Text("Exit", style: TextStyle(color: const Color(0xFF1D1D1B).withOpacity(0.3), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedIndex = index;
        if (index != 0 && DemoState.overrideRole == "BUYER") _deepLinkId = null; 
      }),
      behavior: HitTestBehavior.opaque,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: const Cubic(0.4, 0, 0.2, 1),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1D1D1B).withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF1D1D1B) : const Color(0xFF1D1D1B).withOpacity(0.3),
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF1D1D1B) : const Color(0xFF1D1D1B).withOpacity(0.3),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
