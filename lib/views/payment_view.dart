import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_integracao_clover/view_models/payment_view_model.dart';
import 'package:app_integracao_clover/repositories/payment_repository.dart';
import 'package:app_integracao_clover/repositories/clover_receipts_repository.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(
        paymentRepo: context.read<PaymentRepository>(),
        cloverReceiptsRepo: context.read<CloverReceiptsRepository>(),
      ),
      child: const _PaymentViewBody(),
    );
  }
}

class _PaymentViewBody extends StatelessWidget {
  const _PaymentViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaymentViewModel>();
    final paymentRepo = context.watch<PaymentRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EXEMPLO CLOVER PAY",
          style: TextStyle(
            fontFamily: 'Quicksand',
            fontVariations: [FontVariation('wght', 800)],
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Color(0xFF0A5278),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          if (vm.showInfo) _buildFormWidget(vm),
          if (paymentRepo.isLoading ||
              paymentRepo.status == PaymentStatus.successPayment)
            _buildLoadingWidget(context, vm, paymentRepo.status),
          if (paymentRepo.status == PaymentStatus.finished ||
              paymentRepo.hasError)
            _buildFinishWidget(vm, paymentRepo.status),
        ],
      ),
      floatingActionButton: vm.showInfo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    if (vm.validateForm()) {
                      confirmPaymentDialog(context, vm);
                    }
                  },
                  heroTag: 'btn1',
                  mini: true,
                  backgroundColor: const Color(0xFF0A5278),
                  elevation: 5,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: vm.clearValue,
                  heroTag: 'btn2',
                  mini: true,
                  backgroundColor: const Color(0xFF0A5278),
                  elevation: 5,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
              ],
            )
          : null,
    );
  }

  confirmPaymentDialog(BuildContext mainContext, PaymentViewModel vm) {
    showDialog<String>(
      context: mainContext,
      builder: (BuildContext context) => SimpleDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: const EdgeInsets.only(
          top: 5,
          left: 15,
          right: 10,
          bottom: 5,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Confirmar o Pagamento?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(66, 66, 66, 1),
              ),
            ),
          ],
        ),
        children: [
          const SizedBox(height: 10),
          Text(
            'Forma de pagamento: ${vm.dropdownPaymentMethodValue}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
          Text(
            'Valor: ${vm.paymentFieldValue.text}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
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
                onPressed: () {
                  Navigator.pop(context);
                  vm.confirmPayment(mainContext);
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
                      color: Color(0xFF0A5278),
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
                      color: Color(0xFF0A5278),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormWidget(PaymentViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 10, left: 5, right: 5),
      child: Form(
        key: vm.formKey,
        child: Column(
          children: [
            Card(
              color: Color(0xFF0A5278),
              surfaceTintColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(
                top: 0,
                bottom: 10,
                left: 8,
                right: 8,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 10,
                  right: 10,
                ),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        alignment: Alignment.center,
                        child: const Text(
                          'Informe o valor do pagamento:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: 180,
                          child: TextFormField(
                            controller: vm.paymentFieldValue,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                254,
                                252,
                                252,
                              ),
                              border: const UnderlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              hintText: "Informe o valor",
                              hintStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[500],
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                vm.onValueChanged(value);
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, digite um valor';
                              } else {
                                if (double.parse(
                                      value
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Forma de pagamento:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: 200,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: vm.dropdownPaymentMethodValue,
                  padding: const EdgeInsets.only(left: 10),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFF424242),
                  ),
                  iconSize: 24,
                  dropdownColor: Colors.white,
                  elevation: 8,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(20),
                  underline: const SizedBox(),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                  onChanged: (v) => vm.changePaymentMethod(v!),
                  items: vm.availableMethods
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          alignment: Alignment.center,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(
    BuildContext context,
    PaymentViewModel vm,
    PaymentStatus status,
  ) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 15, left: 15, bottom: 20),
            child: Text(
              'Aguarde enquanto processamos a operação!',
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF0A5278)),
          ),
        ),

        Center(
          child: Card(
            color: const Color(0xFF0A5278),
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
                if (status == PaymentStatus.successPayment ||
                    status == PaymentStatus.loadingSave) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Salvando a transação!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(66, 66, 66, 1),
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
                  vm.resetPayment();
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

  Widget _buildFinishWidget(PaymentViewModel vm, PaymentStatus status) {
    return Column(
      children: [
        const SizedBox(height: 25),
        status == PaymentStatus.finished
            ? Center(
                child: Card(
                  color: const Color(0xFF0A5278),
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
                    onTap: vm.printCupom,
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
            : const SizedBox(),
        status == PaymentStatus.finished
            ? Center(
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 8,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: vm.printClientReceipt,
                    splashColor: Colors.black,
                    child: SizedBox(
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
                            Icon(Icons.person, color: Colors.grey[800]),
                            SizedBox(width: 16),
                            Text(
                              'Imprimir Via do Cliente',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        status == PaymentStatus.finished
            ? Center(
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  elevation: 8,
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onTap: vm.printMerchantReceipt,
                    splashColor: Colors.black,
                    child: SizedBox(
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
                            Icon(Icons.store, color: Colors.grey[800]),
                            SizedBox(width: 16),
                            Text(
                              'Imprimir Via do Lojista',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        Center(
          child: Card(
            color: const Color(0xFF0A5278),
            margin: const EdgeInsets.only(
              top: 30,
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
              onTap: vm.resetPayment,
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
}
