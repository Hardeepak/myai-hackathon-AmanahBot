import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;
import '../services/demo_state.dart';

class ApiService {
  static String get baseUrl {
    final String origin = html.window.location.origin;
    // Use 127.0.0.1 instead of localhost to avoid some Chrome/CORS edge cases
    return origin.contains('localhost') ? 'http://127.0.0.1:8080' : origin;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> createEscrow(
      String itemName, double price, String trackingNumber, String category) async {
    final user = FirebaseAuth.instance.currentUser;
    
    // Support Stealth Demo Mode with fallback UID
    String uid = user?.uid ?? (DemoState.isDemoMode ? "demo_seller_123" : "");
    if (uid.isEmpty) throw Exception("User not authenticated");

    print("POST: $baseUrl/api/escrow/create");

    final response = await http.post(
      Uri.parse('$baseUrl/api/escrow/create'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'item_name': itemName,
        'price': price,
        'tracking_number': trackingNumber,
        'seller_uid': uid,
        'category': category,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create escrow: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getSellerEscrows() async {
    final user = FirebaseAuth.instance.currentUser;
    // In demo mode, we might not have a UID to query Firestore. Fallback to demo UID.
    String uid = user?.uid ?? (DemoState.isDemoMode ? "demo_seller_123" : "");
    if (uid.isEmpty) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('escrows')
        .where('seller_uid', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map<Map<String, dynamic>>((doc) {
      final data = doc.data();
      return {
        ...data,
        'escrow_id': doc.id,
      };
    }).toList();
  }

  static Future<Map<String, dynamic>> uploadReceipt(
      String escrowId, XFile imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/api/escrow/upload-receipt/$escrowId'));
    
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    final bytes = await imageFile.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: imageFile.name,
      contentType: MediaType('image', 'jpeg'),
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload receipt: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getEscrowStatus(String escrowId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/escrow/status/$escrowId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get status: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> raiseDispute(
      String escrowId, String complaint, String sellerResponse, String logs) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/escrow/dispute/$escrowId'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'buyer_complaint': complaint,
        'seller_response': sellerResponse,
        'chat_logs': logs,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to raise dispute: ${response.body}');
    }
  }
}
