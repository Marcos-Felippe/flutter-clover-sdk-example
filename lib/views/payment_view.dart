import 'package:app_integracao_clover/payments/clover/clover_handler.dart';
import 'package:app_integracao_clover/repositories/clover_receipts_repository.dart';
import 'package:app_integracao_clover/repositories/payment_repository.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late PaymentRepository paymentRepo;
  late CloverReceiptsRepository cloverReceiptsRepo;

  static const String appVersion = '1.0.0';

  bool _showInfo = true;

  String dropdownPaymentMethodValue = "Crédito";
  List<String> availableMethods = ["Crédito", "Débito", "PIX"];

  final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final _form = GlobalKey<FormState>();
  final _paymentFieldValue = TextEditingController();

  void validateForm(BuildContext contextTopo) {
    if (_form.currentState!.validate()) {
      confirmPayment(contextTopo);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe todos os dados obrigatorios!',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void confirmPayment(BuildContext contextTopo) {
    showDialog<String>(
      context: contextTopo,
      builder: (BuildContext context) => SimpleDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        contentPadding: const EdgeInsets.only(
          top: 5,
          left: 10,
          right: 10,
          bottom: 5,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.grey[800],
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Confirmar o Pagamento?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color.fromRGBO(66, 66, 66, 1),
              ),
            ),
          ],
        ),
        children: [
          const SizedBox(height: 10),

          Text(
            'Forma de pagamento: $dropdownPaymentMethodValue',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey[700],
            ),
          ),
          Text(
            'Valor: ${_paymentFieldValue.text}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _showInfo = false;
                  });
                  paymentRepo.paymentLoading();
                  Navigator.pop(context);

                  double paymentValue = double.parse(
                    _paymentFieldValue.text
                        .replaceAll('.', '')
                        .replaceAll('R\$', '')
                        .replaceAll(',', '.')
                        .trim(),
                  );

                  final cloverHandler = CloverHandlerService();
                  await cloverHandler.handleCloverPayment(
                    paymentValue,
                    dropdownPaymentMethodValue.toLowerCase(),
                    appVersion,
                    contextTopo,
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    left: 2,
                    right: 2,
                  ),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF43A9E0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                    top: 2,
                    bottom: 2,
                    left: 2,
                    right: 2,
                  ),
                  child: Text(
                    'Voltar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF43A9E0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).then((returnVal) {
      if (returnVal != null) {
        setState(() {});
      }
    });
  }

  // widgets
  Widget _buildInfWidgets(BuildContext contextTopo) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Forma de Recebimento
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Forma de Recebimento',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 400),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton<String>(
                  value: dropdownPaymentMethodValue,
                  padding: const EdgeInsets.only(left: 10),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  dropdownColor: Colors.white,
                  elevation: 8,
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownPaymentMethodValue = newValue!;
                    });
                  },
                  items: availableMethods.map<DropdownMenuItem<String>>((
                    value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Valor
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Valor',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 200.0, maxWidth: 400),
              child: TextFormField(
                controller: _paymentFieldValue,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Informe o valor",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    String stringValue = value.replaceAll(RegExp(r'[^\d]'), '');
                    double doubleValue = double.parse(stringValue) / 100;
                    String currencyFormatedValue = _currencyFormat.format(
                      doubleValue,
                    );
                    _paymentFieldValue.value = TextEditingValue(
                      text: currencyFormatedValue,
                      selection: TextSelection.collapsed(
                        offset: currencyFormatedValue.length,
                      ),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite um valor';
                  } else {
                    if (double.parse(
                          value
                              .replaceAll('.', '')
                              .replaceAll(',', '.')
                              .replaceAll('R\$', ''),
                        ) <=
                        0) {
                      return 'Digite um valor maior que 0';
                    } else {
                      return null;
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingWidgets() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15, left: 15, bottom: 20),
            child: Text(
              'Aguarde enquanto processamos a operação!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(child: CircularProgressIndicator(color: Colors.blue)),
        const SizedBox(height: 20),
        Center(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 20,
              left: 5,
              right: 5,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 5,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onTap: () async {
                // Se a operação já estiver sendo salva no banco
                if (paymentRepo.statusGot == 'success-payment' ||
                    paymentRepo.statusGot == 'loading-baixa') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Salvando a transação!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  paymentRepo.clear();
                  Navigator.pop(context);
                }
              },
              splashColor: Colors.black,
              child: const SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishWidgets() {
    return Column(
      children: [
        const SizedBox(height: 25),
        paymentRepo.statusGot == 'finished'
            ? Center(
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                    left: 5,
                    right: 5,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 5,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Aguarde a impressão!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );

                      final cloverHandler = CloverHandlerService();
                      await cloverHandler.handleCupom();
                    },
                    splashColor: Colors.black,
                    child: const SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.print, color: Colors.white),
                            SizedBox(width: 16),
                            Text(
                              'Imprimir Cupom',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        paymentRepo.statusGot == 'finished'
            ? Center(
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 5,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Aguarde a impressão!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      try {
                        final cloverHandler = CloverHandlerService();
                        await cloverHandler.handlePrintReceipt(
                          cloverReceiptsRepo.clientReceiptValue,
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    splashColor: Colors.black,
                    child: const SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, color: Colors.white),
                            SizedBox(width: 16),
                            Text(
                              'Imprimir Via do Cliente',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        paymentRepo.statusGot == 'finished'
            ? Center(
                child: Card(
                  color: Theme.of(context).colorScheme.primary,
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 5,
                    right: 5,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 5,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Aguarde a impressão!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      try {
                        final cloverHandler = CloverHandlerService();
                        await cloverHandler.handlePrintReceipt(
                          cloverReceiptsRepo.businessReceiptValue,
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    splashColor: Colors.black,
                    child: const SizedBox(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 20,
                          left: 20,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store, color: Colors.white),
                            SizedBox(width: 15),
                            Text(
                              'Imprimir Via do Lojista',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : SizedBox(),
        Center(
          child: Card(
            color: Theme.of(context).colorScheme.primary,
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 30,
              left: 5,
              right: 5,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 5,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onTap: () {
                paymentRepo.clear();
                setState(() {
                  _showInfo = true;

                  _paymentFieldValue.text = "R\$ 0,00";
                });
              },
              splashColor: Colors.black,
              child: const SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay_outlined, color: Colors.white),
                      SizedBox(width: 16),
                      Text(
                        'Novo Pagamento',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _paymentFieldValue.text = "R\$ 0,00";
  }

  @override
  Widget build(BuildContext context) {
    paymentRepo = context.watch<PaymentRepository>();
    cloverReceiptsRepo = context.watch<CloverReceiptsRepository>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: const Text(
            "EXEMPLO CLOVER PAY",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontVariations: [FontVariation('wght', 800)],
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
            onPressed: () {
              if ((paymentRepo.statusGot == 'loading-save' ||
                  paymentRepo.statusGot == 'loading-payment' ||
                  paymentRepo.statusGot == 'success-payment')) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Cancele ou aguarde a transação!',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                paymentRepo.clear();
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _showInfo ? _buildInfWidgets(context) : const SizedBox(),
              paymentRepo.statusGot == 'loading-save' ||
                      paymentRepo.statusGot == 'loading-payment' ||
                      paymentRepo.statusGot == 'success-payment'
                  ? _buildProcessingWidgets()
                  : const SizedBox(),
              paymentRepo.statusGot == 'finished' ||
                      paymentRepo.statusGot == 'error'
                  ? _buildFinishWidgets()
                  : const SizedBox(),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _showInfo
            ? OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'btn1',
                    mini: true,
                    onPressed: () {
                      validateForm(context);
                    },
                    backgroundColor: const Color(0xFF43A9E0),
                    elevation: 5,
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    mini: true,
                    onPressed: () {
                      paymentRepo.clear();
                      setState(() {
                        _paymentFieldValue.text = "R\$ 0,00";
                      });
                    },
                    backgroundColor: const Color(0xFF43A9E0),
                    elevation: 5,
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}
