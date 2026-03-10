package com.mf.app_integracao_clover.clover.printer;

import android.accounts.Account;
import android.content.Context;
import android.graphics.Bitmap;

import com.clover.sdk.util.CloverAccount;
import com.clover.sdk.v1.printer.job.ImagePrintJob2;
import com.clover.sdk.v1.printer.job.PrintJob;
import com.clover.sdk.v1.printer.job.TextPrintJob;


public class CloverPrinterManager {
    private Context context;
    private Account account;

    public CloverPrinterManager(Context context) {
        this.context = context;
        this.account = CloverAccount.getAccount(context);
    }

    public void printBitmap(Bitmap bitmap) {

        new Thread(() -> {
            try {
                PrintJob job = new ImagePrintJob2.Builder(context)
                        .bitmap(bitmap)
                        .build();

                job.print(context, account);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
    }

}
