import 'package:flutter/services.dart';

class CloverPaymentService {
  static const MethodChannel _channel = MethodChannel('clover_smart_flutter');

  Future<Map<String, dynamic>> doPayment(
    int transactionAmount,
    String functionId,
    String appVersion,
  ) async {
    final result = await _channel.invokeMethod('startPayment', {
      'functionId': functionId, // 3 - crédito, 2 - débito, 122 - pix
      'transactionAmount': transactionAmount.toString(),
      'appVersion': appVersion,
    });

    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> printReceipt(String text) async {
    final result = await _channel.invokeMethod('printReceipt', {'text': text});

    return Map<String, dynamic>.from(result);
  }

  Future<Map<String, dynamic>> cupom() async {
    final result = await _channel.invokeMethod('cupom');

    return Map<String, dynamic>.from(result);
  }
}
