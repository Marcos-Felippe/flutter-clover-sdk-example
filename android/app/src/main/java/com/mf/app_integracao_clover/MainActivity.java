package com.mf.app_integracao_clover;

import com.mf.app_integracao_clover.clover.payments.CloverPaymentManager;
import com.mf.app_integracao_clover.clover.printer.CloverPrinterManager;
import com.mf.app_integracao_clover.clover.printer.ReceiptRenderer;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private MethodChannel channel;

    private static final int SITEF_REQUEST_CODE = 1234;

    private MethodChannel.Result pendingResult;

    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread thread, Throwable e) {
                Log.e("GlobalException", "Erro capturado no MainActivity: " + e.getMessage(), e);

                // Você pode também:
                // - Notificar Flutter via MethodChannel
                // - Salvar log local
                // - Encerrar ou reiniciar app
            }
        });
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        context = getApplicationContext();

        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "clover_smart_flutter");

        channel.setMethodCallHandler((call, result) -> {
            try {

                if ("startPayment".equals(call.method)) {

                    pendingResult = result;

                    Intent intent = CloverPaymentManager.generatePaymentIntent(this, call);

                    startActivityForResult(intent, SITEF_REQUEST_CODE);
                }
                else if ("printReceipt".equals(call.method)) {

                    pendingResult = result;

                    String text = call.argument("text");

                    CloverPrinterManager printerManager = new CloverPrinterManager(this);

                    Bitmap receipt = ReceiptRenderer.generateReimpressao(
                            this,
                            text
                    );

                    printerManager.printBitmap(receipt);

                }
                else if ("cupom".equals(call.method)) {

                    pendingResult = result;

                    CloverPrinterManager printerManager = new CloverPrinterManager(this);

                    Bitmap receipt = ReceiptRenderer.generateCupom(
                            this
                    );

                    printerManager.printBitmap(receipt);
                }

            } catch (Exception e) {
                result.error("ERRO_NATIVO", e.getMessage(), e.toString());
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == SITEF_REQUEST_CODE && pendingResult != null) {

            Map<String, Object> response = new HashMap<>();
            response.put("resultCode", resultCode);

            if (data != null && data.getExtras() != null) {
                for (String key : data.getExtras().keySet()) {
                    response.put(key, data.getExtras().get(key));
                }
            }

            pendingResult.success(response);
            pendingResult = null;
        }
    }

    @Override
    public void onDestroy() {
        channel.setMethodCallHandler(null);
        channel = null;
        context = null;
        super.onDestroy();
    }

}

