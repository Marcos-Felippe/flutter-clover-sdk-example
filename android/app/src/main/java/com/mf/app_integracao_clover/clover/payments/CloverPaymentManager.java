package com.mf.app_integracao_clover.clover.payments;

import android.content.Context;
import android.content.Intent;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import io.flutter.plugin.common.MethodCall;

public class CloverPaymentManager {

    static String sitefIntent = "com.fiserv.sitef.action.TRANSACTION";
    static String certifyIntent = "com.fiserv.devrel.action.TRANSACTION";
    static String currentIntent = sitefIntent;

    public static Intent generatePaymentIntent(
            Context context,
            MethodCall call
    ){
        Intent intent = new Intent(currentIntent);

        String functionId = call.argument("functionId");
        String transactionAmount = call.argument("transactionAmount");
        String appVersion = call.argument("appVersion");

        LocalDateTime now = LocalDateTime.now();

        intent.putExtra("functionId", functionId);
        intent.putExtra("transactionAmount", transactionAmount);

        // Dados obrigatórios
        intent.putExtra("merchantTaxId", "CNPJ");
        intent.putExtra("isvTaxId", "CNPJ");
        intent.putExtra("isvAppId", "APPID");
        intent.putExtra("isvAppPackageName", context.getPackageName());
        intent.putExtra("isvAppVersion", appVersion);

        // Dados fiscais
        intent.putExtra("invoiceNumber", now.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
        intent.putExtra("invoiceDate",
                now.format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        intent.putExtra("invoiceTime",
                now.format(DateTimeFormatter.ofPattern("HHmmss")));

        return intent;
    }

}
