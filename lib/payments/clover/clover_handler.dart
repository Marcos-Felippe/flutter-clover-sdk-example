import 'package:app_integracao_clover/payments/clover/clover_payments.dart';
import 'package:app_integracao_clover/utils/change_status.dart';
import 'package:app_integracao_clover/utils/keep_clover_receipts.dart';
import 'package:flutter/material.dart';

class CloverHandlerService {
  handleCloverPayment(
    double valorPg,
    String formaPag,
    String appVersion,
    BuildContext topContext,
  ) async {
    switch (formaPag) {
      case 'crédito':
        double totalNew = valorPg * 100;
        String totalString = "$totalNew";
        List<String> totalStringSplited = totalString.split('.');
        int value = int.parse(totalStringSplited[0]);

        try {
          final clover = CloverPaymentService();
          dynamic success = await clover.doPayment(value, '3', appVersion);

          if (success == null ||
              success['resultCode'] == null ||
              success['responseCode'] == null) {
            break;
          }

          if (success != null &&
              success['resultCode'] != null &&
              success['responseCode'] != null) {
            // sucesso
            if (success['resultCode'] == -1 &&
                success['responseCode'].toString().trim() == "0") {
              ChangeTransactionFlowStatus().success(topContext);
            }
            // falha
            else if (success['resultCode'] == 0) {
              ChangeTransactionFlowStatus().error(topContext);

              if (success['responseCode'].toString() == '-2' ||
                  success['responseCode'].toString() == '-6' ||
                  success['responseCode'].toString() == '-15') {
                ScaffoldMessenger.of(topContext).showSnackBar(
                  const SnackBar(
                    content: Text('Operação cancelada!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                showDialog(
                  context: topContext,
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
            } else {
              showDialog(
                context: topContext,
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
          }
        } catch (e) {
          ChangeTransactionFlowStatus().error(topContext);
          showDialog(
            context: topContext,
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
        break;

      case 'débito':
        double totalNew = valorPg * 100;
        String totalString = "$totalNew";
        List<String> totalStringSplited = totalString.split('.');
        int value = int.parse(totalStringSplited[0]);

        try {
          final clover = CloverPaymentService();
          dynamic success = await clover.doPayment(value, '2', appVersion);

          if (success != null &&
              success['resultCode'] != null &&
              success['responseCode'] != null) {
            // sucesso
            if (success['resultCode'] == -1) {
              if (success['responseCode'].toString().trim() == "0") {
                String viaLojista = success['merchantReceipt'];
                String viaCliente = success['customerReceipt'];

                KeepCloverReceipts().setReceipts(
                  topContext,
                  viaLojista,
                  viaCliente,
                );

                ChangeTransactionFlowStatus().success(topContext);
              } else {
                print('falha');
              }
            }
            // falha
            else if (success['resultCode'] == 0) {
              ChangeTransactionFlowStatus().error(topContext);

              if (success['responseCode'].toString() == '-2' ||
                  success['responseCode'].toString() == '-6' ||
                  success['responseCode'].toString() == '-15') {
                ScaffoldMessenger.of(topContext).showSnackBar(
                  const SnackBar(
                    content: Text('Operação cancelada!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                showDialog(
                  context: topContext,
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
            }
          }
        } catch (e) {
          ChangeTransactionFlowStatus().error(topContext);
          showDialog(
            context: topContext,
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
        break;

      case 'pix':
        double totalNew = valorPg * 100;
        String totalString = "$totalNew";
        List<String> totalStringSplited = totalString.split('.');
        int value = int.parse(totalStringSplited[0]);

        try {
          final clover = CloverPaymentService();
          dynamic success = await clover.doPayment(value, '122', appVersion);

          // resposta do pagamento
          if (success != null &&
              success['resultCode'] != null &&
              success['responseCode'] != null) {
            // sucesso
            if (success['resultCode'] == -1) {
              if (success['responseCode'].toString().trim() == "0") {
                ChangeTransactionFlowStatus().success(topContext);
              } else {
                print('falha');
              }
            }
            // falha
            else if (success['resultCode'] == 0) {
              ChangeTransactionFlowStatus().error(topContext);

              if (success['responseCode'].toString() == '-2' ||
                  success['responseCode'].toString() == '-6' ||
                  success['responseCode'].toString() == '-15') {
                ScaffoldMessenger.of(topContext).showSnackBar(
                  const SnackBar(
                    content: Text('Operação cancelada!'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                showDialog(
                  context: topContext,
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
            }
          }
        } catch (e) {
          ChangeTransactionFlowStatus().error(topContext);
          showDialog(
            context: topContext,
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
        break;
      default:
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
