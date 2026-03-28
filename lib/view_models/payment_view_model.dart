import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app_integracao_clover/payments/clover/clover_handler.dart';
import 'package:app_integracao_clover/repositories/clover_receipts_repository.dart';
import 'package:app_integracao_clover/repositories/payment_repository.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentRepository paymentRepo;
  final CloverReceiptsRepository cloverReceiptsRepo;

  PaymentViewModel({
    required this.paymentRepo,
    required this.cloverReceiptsRepo,
  }) {
    paymentFieldValue.text = "R\$ 0,00";
  }

  static const String appVersion = '1.0.0';

  bool showInfo = true;

  String dropdownPaymentMethodValue = "Crédito";
  List<String> availableMethods = ["Crédito", "Débito", "PIX"];

  final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final formKey = GlobalKey<FormState>();
  final paymentFieldValue = TextEditingController();

  // =========================
  // FORMATAÇÃO
  // =========================
  void onValueChanged(String value) {
    if (value.isNotEmpty) {
      String stringValue = value.replaceAll(RegExp(r'[^\d]'), '');
      double doubleValue = double.parse(stringValue) / 100;

      String formatted = currencyFormat.format(doubleValue);

      paymentFieldValue.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );

      notifyListeners();
    }
  }

  // =========================
  // VALIDAÇÃO
  // =========================
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  double getParsedValue() {
    return double.parse(
      paymentFieldValue.text
          .replaceAll('.', '')
          .replaceAll('R\$', '')
          .replaceAll(',', '.')
          .trim(),
    );
  }

  // =========================
  // AÇÕES
  // =========================
  Future<void> confirmPayment(BuildContext context) async {
    showInfo = false;
    notifyListeners();

    paymentRepo.startPayment();

    final value = getParsedValue();

    final cloverHandler = CloverHandlerService();

    await cloverHandler.handleCloverPayment(
      value,
      dropdownPaymentMethodValue.toLowerCase(),
      appVersion,
      context,
    );
  }

  Future<void> printCupom() async {
    final cloverHandler = CloverHandlerService();
    await cloverHandler.handleCupom();
  }

  Future<void> printClientReceipt() async {
    final cloverHandler = CloverHandlerService();
    await cloverHandler.handlePrintReceipt(
      cloverReceiptsRepo.clientReceiptValue,
    );
  }

  Future<void> printMerchantReceipt() async {
    final cloverHandler = CloverHandlerService();
    await cloverHandler.handlePrintReceipt(
      cloverReceiptsRepo.businessReceiptValue,
    );
  }

  void resetPayment() {
    paymentRepo.clear();
    showInfo = true;
    paymentFieldValue.text = "R\$ 0,00";
    notifyListeners();
  }

  void clearValue() {
    paymentRepo.clear();
    paymentFieldValue.text = "R\$ 0,00";
    notifyListeners();
  }

  void changePaymentMethod(String value) {
    dropdownPaymentMethodValue = value;
    notifyListeners();
  }
}
