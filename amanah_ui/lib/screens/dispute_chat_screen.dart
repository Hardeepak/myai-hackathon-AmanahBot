import 'package:flutter/material.dart';

class DisputeChatScreen extends StatelessWidget {
  const DisputeChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep Slate
      appBar: AppBar(
        title: const Text("AI Mediator Agent"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.history_edu, color: Colors.blueAccent), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Dynamic Case Status
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: Colors.blueAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("STATUS: MEDIATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueAccent)),
                      Text("Mediating based on MY Consumer Act 1999", style: TextStyle(fontSize: 10, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                ChatBubble(text: "Saya Amanah AI. I've reviewed your Jordan 1 transaction. The seller hasn't shipped in 48 hours. Want to trigger a refund?", isAi: true),
                ChatBubble(text: "Yes, please. Seller is not responding.", isAi: false),
                ChatBubble(text: "Processing... Checking Seller's bank standing. Refund eligibility: 98%.", isAi: true),
              ],
            ),
          ),
          
          // Modern Chat Input
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Message AI Mediator...",
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.arrow_upward, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isAi;
  const ChatBubble({super.key, required this.text, required this.isAi});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isAi ? Colors.white.withOpacity(0.08) : Colors.blueAccent,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: Radius.circular(isAi ? 0 : 20),
            bottomRight: Radius.circular(isAi ? 20 : 0),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }
}