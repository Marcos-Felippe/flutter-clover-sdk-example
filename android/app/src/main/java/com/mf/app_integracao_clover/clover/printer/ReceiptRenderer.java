package com.mf.app_integracao_clover.clover.printer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;

import com.mf.app_integracao_clover.R;
import io.flutter.plugin.common.MethodCall;

public class ReceiptRenderer {
    static int printerWidth = 384;
    static int marginLeft = 16;

    public static Bitmap generateCupom(
            Context context
    ) {
        String text = "Texto aleatorio";
        int y = 20;

        // ======================
        // LOGO
        // ======================
        Bitmap logo = BitmapFactory.decodeResource(
                context.getResources(),
                R.drawable.logo_recibo
        );

        int logoWidth = 300;
        float ratio = (float) logo.getHeight() / logo.getWidth();
        int logoHeight = Math.round(logoWidth * ratio);

        Bitmap scaledLogo = Bitmap.createScaledBitmap(
                logo,
                logoWidth,
                logoHeight,
                false
        );

        // ======================
        // TEXTO FIXO
        // ======================
        TextPaint textPaint = new TextPaint();
        textPaint.setColor(Color.BLACK);
        textPaint.setTextSize(22f);
        textPaint.setAntiAlias(false); // IMPORTANTE
        textPaint.setTypeface(Typeface.MONOSPACE);
        textPaint.setTextAlign(Paint.Align.LEFT);

        StaticLayout layout = new StaticLayout(
                text,
                textPaint,
                printerWidth - (marginLeft * 2),
                Layout.Alignment.ALIGN_NORMAL,
                1.0f,
                0.0f,
                false
        );

        int totalHeight = logoHeight + 30 + layout.getHeight() + 40;

        Bitmap bmp = Bitmap.createBitmap(
                printerWidth,
                totalHeight,
                Bitmap.Config.RGB_565
        );

        Canvas canvas = new Canvas(bmp);
        canvas.drawColor(Color.WHITE);

        // ======================
        // DESENHA LOGO CENTRALIZADA
        // ======================
        int logoX = (printerWidth - logoWidth) / 2;
        canvas.drawBitmap(scaledLogo, logoX, y, null);

        y += logoHeight + 30;

        // ======================
        // DESENHA TEXTO À ESQUERDA
        // ======================
        canvas.save();
        canvas.translate(marginLeft, y);
        layout.draw(canvas);
        canvas.restore();

        return bmp;
    }

    public static Bitmap generateReimpressao(
            Context context,
            String text
    ) {

        // ======================
        // TEXTO FIXO
        // ======================
        TextPaint textPaint = new TextPaint();
        textPaint.setColor(Color.BLACK);
        textPaint.setTextSize(16f);
        textPaint.setAntiAlias(false); // IMPORTANTE
        textPaint.setTypeface(Typeface.MONOSPACE);
        textPaint.setTextAlign(Paint.Align.LEFT);

        StaticLayout layout = new StaticLayout(
                text,
                textPaint,
                printerWidth,
                Layout.Alignment.ALIGN_NORMAL,
                1.0f,
                0.0f,
                false
        );

        int totalHeight = layout.getHeight() + 40;

        Bitmap bmp = Bitmap.createBitmap(
                printerWidth,
                totalHeight,
                Bitmap.Config.RGB_565
        );

        Canvas canvas = new Canvas(bmp);
        canvas.drawColor(Color.WHITE);

        // ======================
        // DESENHA TEXTO À ESQUERDA
        // ======================
        canvas.save();
        canvas.translate(0, 0);
        layout.draw(canvas);
        canvas.restore();

        return bmp;
    }
}
