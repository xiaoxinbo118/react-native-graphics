package com.evan.graphics.command;

import android.graphics.Canvas;
import android.graphics.Rect;

import com.facebook.react.bridge.ReadableMap;



public abstract class Command {
    public String name;
    public ReadableMap params;
    public Rect previousRect;
    public Rect rect;
    public int canvasWidth;
    public int canvasHeight;

    private Command() {

    }

    protected Command(ReadableMap cmd, int canvasWidth, int canvasHeight, Rect previousRect) {
        this.canvasWidth = canvasWidth;
        this.canvasHeight = canvasHeight;
        this.previousRect = previousRect;
        this.name = cmd.getString("cmd");
        this.params = cmd;
    }

    public static Command command(ReadableMap cmd, int canvasWidth, int canvasHeight, Rect previousRect) {
        String name = cmd.getString("cmd");
        Command result = null;

        switch (name) {
            case "fillText":
                result = new FillTextCommand(cmd, canvasWidth, canvasHeight, previousRect);
                break;
            case "drawImage":
                result = new DrawImageCommand(cmd, canvasWidth, canvasHeight, previousRect);
                break;
            case "drawBarcode":
                result = new DrawBarcodeCommand(cmd, canvasWidth, canvasHeight, previousRect);
                break;
        }

        return result;
    }

    public abstract PrepareHandler getPrepare();

    public abstract void excute(Canvas canvas);
}
