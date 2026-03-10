import 'package:flutter/material.dart';

class PaymentRepository extends ChangeNotifier {
  String status = "none";

  String get statusGot => status;

  clear() {
    status = "none";
    notifyListeners();
  }

  paymentLoading() {
    status = "loading-payment";
    notifyListeners();
  }

  paymentSuccess() {
    status = "success-payment";
    notifyListeners();
  }

  savingLoading() {
    status = "loading-save";
    notifyListeners();
  }

  finished() {
    status = "finished";
    notifyListeners();
  }

  cancel() {
    status = "cancel";
    notifyListeners();
  }

  error() {
    status = "error";
    notifyListeners();
  }
}
