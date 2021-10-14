package com.evan.graphics;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;

public class RNGraphicsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public RNGraphicsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void draw(ReadableArray cmds,
                     int width,
                     int height,
                     boolean ignoreImageDownloadError,
                     final Promise promise) {
        CommandExcutor excutor = new CommandExcutor(cmds, width, height, ignoreImageDownloadError);
        excutor.excute(this.getCurrentActivity(), new CommandExcuteHandler() {
            @Override
            public void onSuccess(String filePath) {
                promise.resolve(filePath);
            }

            @Override
            public void onError(int code, String message) {
                promise.reject(code + "" , message);
            }
        });
    }

    @Override
    public String getName() {
        return "RNGraphics";
    }
}
