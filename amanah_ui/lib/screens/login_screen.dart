import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/demo_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _syncUserToFirestore(User user) async {
    final String email = user.email ?? "";
    String role = DemoState.overrideRole ?? "GUEST";
    
    if (email == "seller@gmail.com") role = "SELLER";
    if (email == "buyer@gmail.com") role = "BUYER";

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'role': role,
        'last_login': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Firestore Sync Warning: $e");
    }
  }

  void _signIn() async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields")));
       setState(() => _isLoading = false);
       return;
    }

    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _syncUserToFirestore(result.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'configuration-not-found') {
        try {
          UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          _syncUserToFirestore(result.user!);
        } catch (createError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Auth Failed: [${e.code}]. Enable Email Auth in Firebase!"),
            duration: const Duration(seconds: 5),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Auth Error: [${e.code}] ${e.message}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("General Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _activateDemoBypass(String role) {
    DemoState.activateDemo(role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, color: Colors.blueAccent, size: 64),
                  const SizedBox(height: 24),
                  Text("AMANAH-BOT", style: GoogleFonts.lora(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 4)),
                  const SizedBox(height: 8),
                  const Text("Zero-Trust AI Escrow", style: TextStyle(color: Colors.white38)),
                  const SizedBox(height: 48),
                  _buildField("Email", _emailController, false),
                  const SizedBox(height: 16),
                  _buildField("Password", _passwordController, true),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIGN IN / AUTO-CREATE"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // NON-OBVIOUS DEMO BYPASS BUTTONS
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () => _activateDemoBypass("SELLER"),
              child: Opacity(
                opacity: 0.15,
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.white24, size: 8),
                    const SizedBox(width: 8),
                    Text("S-PORTAL", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => _activateDemoBypass("BUYER"),
              child: Opacity(
                opacity: 0.15,
                child: Row(
                  children: [
                    Text("B-PORTAL", style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10, letterSpacing: 1)),
                    const SizedBox(width: 8),
                    const Icon(Icons.circle, color: Colors.white24, size: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool obscure) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white30),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
