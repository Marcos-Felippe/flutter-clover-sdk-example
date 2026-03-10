import 'package:flutter/material.dart';

class CloverReceiptsRepository extends ChangeNotifier {
  String _clientReceipt = "none";
  String _businessReceipt = "none";

  String get clientReceiptValue => _clientReceipt;
  String get businessReceiptValue => _businessReceipt;

  setReceipts(String business, String client) {
    _clientReceipt = client;
    _businessReceipt = business;
  }
}
