import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../widgets/glass_card.dart';
import 'dart:html' as html;

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  final _trackingController = TextEditingController();
  String _selectedCategory = "Online Business";
  bool _isLoading = false;
  String? _generatedId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _createLink() async {
    if (_itemController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in item name and price")));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.createEscrow(
        _itemController.text,
        double.parse(_priceController.text),
        _trackingController.text,
        _selectedCategory,
      );
      setState(() {
        _generatedId = res['escrow_id'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SELLER COMMAND CENTER", style: TextStyle(color: Colors.white70, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white24,
          labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          tabs: const [
            Tab(text: "CREATE", icon: Icon(Icons.add_link, size: 18)),
            Tab(text: "MANAGE", icon: Icon(Icons.grid_view_rounded, size: 18)),
            Tab(text: "ANALYTICS", icon: Icon(Icons.insights_rounded, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateTab(),
          _buildManageTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("New Escrow", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const Text("Select a template to generate a secure link.", style: TextStyle(color: Colors.white38, fontSize: 16)),
          const SizedBox(height: 30),
          _buildCategorySelector(),
          const SizedBox(height: 20),
          _buildInputField("Item Name", _itemController, Icons.shopping_bag_outlined),
          _buildInputField("Price (RM)", _priceController, Icons.payments_outlined, isNumber: true),
          if (_selectedCategory != "Roadside Stall")
            _buildInputField("Tracking Number (Optional)", _trackingController, Icons.local_shipping_outlined),
          const SizedBox(height: 20),
          if (_generatedId != null) _buildResultCard(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _createLink,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("GENERATE SECURE LINK"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = ["Online Business", "Roadside Stall", "SME"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        bool selected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? Colors.blueAccent : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: selected ? Colors.blueAccent : Colors.white10),
            ),
            child: Text(cat, style: TextStyle(color: selected ? Colors.white : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildManageTab() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('escrows')
          .where('seller_uid', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text("No transactions yet.", style: TextStyle(color: Colors.white38)));

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final id = docs[index].id;
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['item'] ?? "Item", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("ID: $id", style: const TextStyle(color: Colors.white24, fontSize: 10, fontFamily: 'monospace')),
                    ],
                  ),
                  const Spacer(),
                  _buildStatusBadge(data['status']),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color = Colors.blueAccent;
    if (status == "Released") color = Colors.greenAccent;
    if (status == "Disputed" || status == "AUTO_DISPUTED") color = Colors.redAccent;
    if (status == "Funded") color = Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(status?.toUpperCase() ?? "PENDING", style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
    );
  }

  Widget _buildAnalyticsTab() {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('escrows')
          .where('seller_uid', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        
        int released = docs.where((d) => d['status'] == "Released").length;
        int disputed = docs.where((d) => d['status'] == "Disputed" || d['status'] == "AUTO_DISPUTED").length;
        int active = docs.length - released - disputed;
        double totalVolume = docs.fold(0.0, (sum, d) => sum + (d['price'] ?? 0.0));

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Performance Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 30),
              Row(
                children: [
                  _buildStatCard("Total Volume", "RM ${totalVolume.toStringAsFixed(2)}", Icons.account_balance_wallet_outlined),
                  const SizedBox(width: 16),
                  _buildStatCard("Success Rate", "${docs.isEmpty ? 0 : (released / docs.length * 100).toInt()}%", Icons.verified_outlined),
                ],
              ),
              const SizedBox(height: 40),
              const Text("Transaction Health", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(value: released.toDouble(), color: Colors.greenAccent, title: 'Success', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                      PieChartSectionData(value: disputed.toDouble(), color: Colors.redAccent, title: 'Fraud', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                      PieChartSectionData(value: active.toDouble(), color: Colors.blueAccent, title: 'Active', radius: 50, titleStyle: const TextStyle(fontSize: 10, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // --- REUSED UTILS ---
  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.5)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white30, fontSize: 14),
          filled: true,
          fillColor: Colors.white.withOpacity(0.03),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white10)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blueAccent)),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.blueAccent.withOpacity(0.3))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 8),
              Text("LINK SECURED: $_generatedId", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => Clipboard.setData(ClipboardData(text: _generatedId!)), icon: const Icon(Icons.copy, size: 18), label: const Text("COPY RAW ID"), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white24)))),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () {
                final String origin = html.window.location.origin;
                Clipboard.setData(ClipboardData(text: "$origin/?id=$_generatedId"));
              }, icon: const Icon(Icons.link, size: 18, color: Colors.white), label: const Text("SHARE AUTO-APPLY LINK"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green.withOpacity(0.6)))),
            ],
          )
        ],
      ),
    );
  }
}
