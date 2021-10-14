package com.evan.graphics.command;

import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;

import com.facebook.react.bridge.ReadableMap;

public class FillTextCommand extends Command {
    private String text;
    private Paint paint;
    public FillTextCommand(ReadableMap cmd, int canvasWidth, int canvasHeight, Rect previousRect) {
        super(cmd, canvasWidth, canvasHeight, previousRect);

        this.text = cmd.getString("text");
        this.paint = new Paint();

        ReadableMap style = cmd.getMap("style");

        if (style == null) {
            return;
        }

//        paint.setColor();
    }

    @Override
    public PrepareHandler getPrepare() {
        return null;
    }

    @Override
    public void excute(Canvas canvas) {
        if (this.text == null || "".equals(this.text)) {
            return;
        }

        // 设置画笔
        TextPaint textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG | Paint.DEV_KERN_TEXT_FLAG);
        // 抗锯齿
        textPaint.setAntiAlias(true);
        // 防抖动
        textPaint.setDither(true);
        textPaint.setTextSize(50);

        textPaint.setColor(Color.rgb(51, 51, 51));

        int titleRegionSize = this.rect.width();

        int textStartY = this.rect.top;
        int titleHeight = 0;

//        StaticLayout.Builder builder = StaticLayout.Builder.obtain(this.text, 0, this.text.length(), textPaint, this.rect.width());


        StaticLayout titleLayout = null;

        titleLayout = new StaticLayout(
                this.text,
                0,
                this.text.length(),
                textPaint,
                titleRegionSize,
                Layout.Alignment.ALIGN_NORMAL,
                1.1f,
                0.0f,
                false
        );

        titleLayout = new StaticLayout(
                this.text,
                textPaint,
                titleRegionSize,
                Layout.Alignment.ALIGN_NORMAL,
                1.1f,
                0.0f,
                false
        );

        titleLayout.

        titleHeight = titleLayout.getHeight();
        int line = titleLayout.getLineCount();
        //最多两行
        if (line>2){
            int two = titleLayout.getLineStart(2);
            int start = 0;
            titleLayout = new StaticLayout(
                    this.text.substring(start,two-3).concat(".."),
                    textPaint,
                    titleRegionSize,
                    Layout.Alignment.ALIGN_NORMAL,
                    1.1f,
                    0,
                    false
            );
        }

        canvas.save();
        //往下移动一下
        Paint.FontMetrics fontMetrics = textPaint.getFontMetrics();
        canvas.translate(padding, textStartY+padding+fontMetrics.descent);

        titleLayout.draw(canvas);
        titleHeight = titleLayout.getHeight();
        canvas.restore();
    }
}
