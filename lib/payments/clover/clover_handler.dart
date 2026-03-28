import 'package:app_integracao_clover/payments/clover/clover_payments.dart';
import 'package:app_integracao_clover/utils/change_status.dart';
import 'package:app_integracao_clover/utils/keep_clover_receipts.dart';
import 'package:flutter/material.dart';

class CloverHandlerService {
  int _toCents(double value) {
    double totalNew = value * 100;
    String totalString = "$totalNew";
    List<String> totalStringSplited = totalString.split('.');
    return int.parse(totalStringSplited[0]);
  }

  bool _isValidResponse(Map<String, dynamic>? res) {
    return res != null &&
        res['resultCode'] != null &&
        res['responseCode'] != null;
  }

  bool _isSuccess(Map<String, dynamic> res) {
    return res['resultCode'] == -1 &&
        res['responseCode'].toString().trim() == "0";
  }

  bool _isCancelled(String code) {
    return ['-2', '-6', '-15'].contains(code);
  }

  void _handleError(BuildContext context, String responseCode) {
    ChangeTransactionFlowStatus().error(context);

    if (_isCancelled(responseCode)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operação cancelada!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      showErrorDialog(context);
    }
  }

  Future<void> _processPayment({
    required BuildContext context,
    required int value,
    required String paymentCode,
    required String appVersion,
    bool saveReceipt = false,
  }) async {
    try {
      final clover = CloverPaymentService();
      final response = await clover.doPayment(value, paymentCode, appVersion);

      if (!_isValidResponse(response)) return;

      final resultCode = response['resultCode'];
      final responseCode = response['responseCode'].toString();

      if (_isSuccess(response)) {
        if (saveReceipt) {
          KeepCloverReceipts().setReceipts(
            context,
            response['merchantReceipt'],
            response['customerReceipt'],
          );
        }

        ChangeTransactionFlowStatus().success(context);
      } else if (resultCode == 0) {
        _handleError(context, responseCode);
      } else {
        showErrorDialog(context);
      }
    } catch (e) {
      ChangeTransactionFlowStatus().error(context);
      showErrorDialog(context);
    }
  }

  showErrorDialog(BuildContext mainContext) {
    showDialog(
      context: mainContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Erro no processamento!\nTente novamente.',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  handleCloverPayment(
    double valorPg,
    String formaPag,
    String appVersion,
    BuildContext mainContext,
  ) async {
    final int value = _toCents(valorPg);

    switch (formaPag) {
      case 'crédito':
        await _processPayment(
          context: mainContext,
          value: value,
          paymentCode: '3',
          appVersion: appVersion,
          saveReceipt: true,
        );
        break;

      case 'débito':
        await _processPayment(
          context: mainContext,
          value: value,
          paymentCode: '2',
          appVersion: appVersion,
          saveReceipt: true,
        );
        break;

      case 'pix':
        await _processPayment(
          context: mainContext,
          value: value,
          paymentCode: '122',
          appVersion: appVersion,
          saveReceipt: true,
        );
        break;
    }
  }

  handlePrintReceipt(String text) async {
    final clover = CloverPaymentService();

    try {
      // Chamando a reimpressão
      dynamic success = await clover.printReceipt(text);

      print("Impresso");
    } catch (e) {
      print("erro: ${e}");
    }
  }

  handleCupom() async {
    final clover = CloverPaymentService();

    dynamic success = await clover.cupom();
    print(success);
  }
}
