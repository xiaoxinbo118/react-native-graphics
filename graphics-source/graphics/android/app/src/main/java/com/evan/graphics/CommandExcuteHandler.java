package com.evan.graphics;

public interface CommandExcuteHandler {
    public void onSuccess(String filePath);
    public void onError(int code, String message);
}
