package com.evan.graphics.command;

import android.graphics.Canvas;
import android.graphics.Rect;

import com.facebook.react.bridge.ReadableMap;

public class DrawBarcodeCommand extends Command {
    public DrawBarcodeCommand(ReadableMap cmd, int canvasWidth, int canvasHeight, Rect previousRect) {
        super(cmd, canvasWidth, canvasHeight, previousRect);
    }

    @Override
    public PrepareHandler getPrepare() {
        return null;
    }

    @Override
    public void excute(Canvas canvas) {

    }
}
