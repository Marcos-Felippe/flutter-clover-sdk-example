import 'package:flutter/material.dart';

/// Representa todos os estados possíveis do pagamento
enum PaymentStatus {
  none,
  loadingPayment,
  successPayment,
  loadingSave,
  finished,
  canceled,
  error,
}

class PaymentRepository extends ChangeNotifier {
  PaymentStatus _status = PaymentStatus.none;

  PaymentStatus get status => _status;

  bool get isLoading =>
      _status == PaymentStatus.loadingPayment ||
      _status == PaymentStatus.loadingSave;

  bool get isSuccess => _status == PaymentStatus.successPayment;

  bool get hasError => _status == PaymentStatus.error;

  void _setStatus(PaymentStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void clear() => _setStatus(PaymentStatus.none);

  void startPayment() => _setStatus(PaymentStatus.loadingPayment);

  void paymentSuccess() => _setStatus(PaymentStatus.successPayment);

  void startSaving() => _setStatus(PaymentStatus.loadingSave);

  void finish() => _setStatus(PaymentStatus.finished);

  void cancel() => _setStatus(PaymentStatus.canceled);

  void setError() => _setStatus(PaymentStatus.error);
}
