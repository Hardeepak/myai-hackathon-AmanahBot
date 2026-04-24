import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/reasoning_bar.dart';
import '../services/api_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String? escrowId;
  const CheckoutScreen({super.key, this.escrowId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _status = "Payment_Pending";
  String _reasoning = "Waiting for DuitNow receipt upload...";
  String _itemName = "Secure Transaction";
  String _itemPrice = "0.00";
  List<String> _agentLogs = ["SYSTEM: Connection established.", "READY: Waiting for user action."];
  bool _isAnalyzing = false;
  Timer? _pollingTimer;
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController.addListener(_onIdChanged);
    if (widget.escrowId != null) {
      _idController.text = widget.escrowId!;
    }
  }

  void _onIdChanged() {
    final id = _idController.text.trim();
    if (id.length == 8) {
      _fetchStatus(id);
      _startStatusPolling(id); // FIXED: Start polling immediately on ID match
    }
  }

  void _fetchStatus(String id) async {
    try {
      final res = await ApiService.getEscrowStatus(id);
      setState(() {
        _status = res['status'];
        _itemName = res['item'] ?? "Secure Item";
        _itemPrice = (res['price'] ?? 0.0).toStringAsFixed(2);
        _agentLogs = List<String>.from(res['logs'] ?? []);
        
        // Update reasoning based on existing status
        if (_status == "Released") {
           _reasoning = "SUCCESS: Autonomous payout executed.";
        } else if (_status == "In_Transit") {
           _reasoning = "AGENT: Courier confirmed pickup. Monitoring...";
        }
      });
    } catch (e) {
      print("Status fetch error: $e");
    }
  }

  // Visual Stepper Logic
  int _currentStep() {
    switch (_status) {
      case "Payment_Pending": return 0;
      case "Funded": return 2; // Step 2 "Done"
      case "In_Transit": return 3;
      case "Delivered": return 4;
      case "Released": return 5;
      case "Disputed": return 1; 
      default: return 0;
    }
  }

  void _pickAndUpload() async {
    final id = _idController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid Escrow ID")));
      return;
    }
    
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _isAnalyzing = true;
        _reasoning = "AGENT: Scanning pixels for forensic manipulation...";
        _agentLogs.add("AI BRIDGE: Initializing multimodal forensics...");
      });
      
      try {
        final res = await ApiService.uploadReceipt(id, image);
        setState(() {
          _status = res['current_status'];
          _reasoning = res['ai_verdict']['reasoning'] ?? "AI confirmed authenticity.";
          _agentLogs = List<String>.from(res['ai_verdict']['logs'] ?? _agentLogs);
          _isAnalyzing = false;
        });
        _startStatusPolling(id);
      } catch (e) {
        setState(() {
          _isAnalyzing = false;
          _reasoning = "ERROR: Bridge failed.";
          _agentLogs.add("CRITICAL: Failed to reach AI node.");
        });
      }
    }
  }

  void _startStatusPolling(String id) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      try {
        final res = await ApiService.getEscrowStatus(id);
        setState(() {
          _status = res['status'];
          _agentLogs = List<String>.from(res['logs'] ?? []);
          if (_status == "Released") {
            _reasoning = "SUCCESS: Autonomous payout executed.";
            timer.cancel();
          }
        });
      } catch (e) {
        timer.cancel();
      }
    });
  }

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
              _buildHeader(),
              const SizedBox(height: 30),
              _buildStepper(),
              const SizedBox(height: 40),
              _buildProductCard(),
              const SizedBox(height: 24),
              _buildAgentConsole(), // THE NEW CONSOLE
              const SizedBox(height: 24),
              if (_status == "Payment_Pending") _buildActionButton(),
              const SizedBox(height: 40),
              const Center(child: Text("🔒 AMANAH-CORE PROTOCOL ACTIVE", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 1.5))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(children: [
      const Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 24),
      const SizedBox(width: 10),
      const Text("AMANAH", style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16)),
      const Spacer(),
      if (_isAnalyzing) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent)),
    ]);
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        bool isDone = index < _currentStep();
        bool isCurrent = index == _currentStep();
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? Colors.greenAccent : (isCurrent ? Colors.blueAccent : Colors.white10),
                  border: Border.all(color: isCurrent ? Colors.white24 : Colors.transparent),
                ),
                child: Center(
                  child: isDone 
                    ? const Icon(Icons.check, size: 14, color: Colors.black)
                    : Text("${index + 1}", style: TextStyle(color: isCurrent ? Colors.white : Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
              if (index < 4) Expanded(child: Container(height: 1, color: isDone ? Colors.greenAccent.withOpacity(0.3) : Colors.white10)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: [
        TextField(
          controller: _idController,
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
          textAlign: TextAlign.center,
          decoration: const InputDecoration(hintText: "PASTE ESCROW ID", hintStyle: TextStyle(color: Colors.white10), border: InputBorder.none),
        ),
        const SizedBox(height: 12),
        Text(_itemName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("RM $_itemPrice", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
      ]),
    );
  }

  Widget _buildAgentConsole() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.terminal, color: Colors.greenAccent, size: 14),
            SizedBox(width: 8),
            Text("AGENT_ACTIVITY_LOG", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
          ]),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _agentLogs.length,
              itemBuilder: (context, index) {
                final log = _agentLogs.reversed.toList()[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text("> $log", style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace')),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0
        ),
        onPressed: _pickAndUpload,
        child: const Text("UPLOAD PROOF OF PAYMENT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
