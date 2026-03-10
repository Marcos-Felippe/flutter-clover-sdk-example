import 'package:app_integracao_clover/repositories/clover_receipts_repository.dart';
import 'package:app_integracao_clover/repositories/payment_repository.dart';
import 'package:app_integracao_clover/views/payment_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xFF43A9E0),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PaymentRepository>(
          create: (_) => PaymentRepository(),
        ),

        ChangeNotifierProvider<CloverReceiptsRepository>(
          create: (_) => CloverReceiptsRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      title: 'Exemplo Clover Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF43A9E0),
          secondary: Colors.blue,
          tertiary: const Color.fromARGB(255, 255, 132, 0),
          surface: Colors.white,
          onSurface: Colors.black,
          outline: Colors.black,
        ),
        useMaterial3: false,
      ),
      home: const PaymentView(),
    );
  }
}
