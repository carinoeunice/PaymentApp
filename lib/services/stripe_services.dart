import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/strip_config.dart';

class StripeService {
  static const Map<String, String> _testTokens = {
    '4242424242424242': 'tok_visa',
    '4000000000000002': 'tok_chargeDeclined',
    '400000034576934': 'tok_visa_debit',
    '5555555555554444': 'tok_mastercard',
    '5200828282828210': 'tok_mastercard_debit',
    '4000000000009995': 'tok_chargeDeclinedInsufficientFunds',
  };

  static Future<Map<String, dynamic>> processPayment({
    required double amount,
    required String cardNumber,
    required String expMonth,
    required String expYear,
    required String cvc,
  }) async {
    final amountInCentavos = (amount * 100).round().toString();
    final cleanCard = cardNumber.trim().replaceAll(RegExp(r'\D'), '');

    if (cleanCard.isEmpty) {
      return {
        'success': false,
        'error': 'Please enter a card number.',
      };
    }

    final token = _testTokens[cleanCard];

    if (token == null) {
      return {
        'success': false,
        'error': 'Unknown test card ($cleanCard). Use 4242424242424242 for testing.',
      };
    }

    // --- SIMULATION MODE ---
    // If you haven't set a real Secret Key, we simulate the response locally.
    if (StripeConfig.secretKey == "YOUR_SECRET_KEY_HERE" || StripeConfig.secretKey.isEmpty) {
      await Future.delayed(const Duration(seconds: 2)); // Simulate network lag
      
      if (token == 'tok_visa' || token == 'tok_visa_debit' || token == 'tok_mastercard') {
        return {
          'success': true,
          'id': 'sim_capture_${DateTime.now().millisecondsSinceEpoch}',
          'amount': amount,
          'status': 'succeeded',
        };
      } else {
        return {
          'success': false,
          'error': 'Simulation: Your card was declined.',
        };
      }
    }

    // --- REAL API CALL ---
    try {
      final response = await http.post(
        Uri.parse('${StripeConfig.apiUrl}/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeConfig.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCentavos,
          'currency': 'php',
          'payment_method_data[type]': 'card',
          'payment_method_data[card][token]': token,
          'confirm': 'true',
          'return_url': 'https://example.com/return', // Required for confirm: true
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'succeeded') {
        return {
          'success': true,
          'id': data['id'],
          'amount': (data['amount'] as num) / 100,
          'status': data['status'],
        };
      } else {
        return {
          'success': false,
          'error': data['error']?['message'] ?? 'Payment failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
