import 'package:app_integracao_clover/repositories/clover_receipts_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeepCloverReceipts {
  void setReceipts(BuildContext context, String lojista, String cliente) async {
    var cloverReceiptsRepo = Provider.of<CloverReceiptsRepository>(
      context,
      listen: false,
    );
    cloverReceiptsRepo.setReceipts(lojista, cliente);
  }
}
