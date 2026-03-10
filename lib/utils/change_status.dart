import 'package:app_integracao_clover/repositories/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeTransactionFlowStatus {
  void success(BuildContext context) async {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);

    paymentRepo.paymentSuccess();
    paymentRepo.savingLoading();
    // Logica para salvar no banco...
    paymentRepo.finished();
  }

  void savingLoading(BuildContext context) {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);
    paymentRepo.savingLoading();
  }

  void error(BuildContext context) {
    var paymentRepo = Provider.of<PaymentRepository>(context, listen: false);
    paymentRepo.error();
  }
}
