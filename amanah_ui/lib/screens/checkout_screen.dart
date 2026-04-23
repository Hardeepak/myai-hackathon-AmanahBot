import 'package:flutter/material.dart';
import '../widgets/reasoning_bar.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Malaysian Flag Accent Header
              Row(
                children: [
                  Container(width: 4, height: 24, color: Colors.yellowAccent),
                  const SizedBox(width: 8),
                  const Text("AMANAH-BOT", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.white70)),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Secure Escrow Payment", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 10),
              
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent.withOpacity(0.15), Colors.transparent]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text("Sneakers - Jordan 1 Retro", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    const Text("RM 450.00", style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(height: 12),
                    const ReasoningBar(reasoning: "AI Vision: Scanning for manipulated text in DuitNow receipt..."),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              // Interaction Buttons
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {},
                  child: const Text("UPLOAD PROOF OF PAYMENT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
              const Center(child: Text("🔒 256-bit Encrypted Zero-Trust Protocol", style: TextStyle(color: Colors.white24, fontSize: 10))),
            ],
          ),
        ),
      ),
    );
  }
}