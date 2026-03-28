import 'package:app_integracao_clover/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeTransactionFlowStatus {
  void success(BuildContext context) async {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);

    paymentRepo.paymentSuccess();
    paymentRepo.startSaving();
    // Logica para salvar no banco...
    paymentRepo.finish();
  }

  void savingLoading(BuildContext context) {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);
    paymentRepo.startSaving();
  }

  void error(BuildContext context) {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);
    paymentRepo.setError();
  }
}
