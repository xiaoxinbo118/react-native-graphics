package com.evan.graphics;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Rect;
import android.os.Environment;

import com.evan.graphics.command.Command;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CommandExcutor {
    private List<Command> commands;
    private int width;
    private int height;
    public CommandExcutor(ReadableArray cmds,
                          int width,
                          int height,
                          boolean ignoreImageDownloadError) {
        int cmdLen = cmds.size();

        Rect previousRect = new Rect();

        this.commands = new ArrayList<Command>();
        for (int i = 0; i < cmdLen; i++) {
            ReadableMap map = cmds.getMap(i);
            Command command = Command.command(map, width, height, previousRect);
            if (command != null) {
                this.commands.add(command);
            }
        }
    }

    public void excute(Context context, CommandExcuteHandler handler) {
        Bitmap b = Bitmap.createBitmap(this.width, this.width, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(b);

        for (Command command: this.commands) {
            command.excute(canvas);
        }



        File cacheDir = null;
        if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())) {
            cacheDir = context.getExternalCacheDir();
        } else {
            cacheDir = context.getCacheDir();
        }

        String uuid = UUID.randomUUID().toString();

        // todo 异步
        try {
            File picFile = new File(cacheDir.getPath() + File.separator + uuid + ".jpeg");

            if (!picFile.exists()) {
                picFile.getParentFile().mkdirs();
                picFile.createNewFile();
            }

            FileOutputStream fos = new FileOutputStream(picFile);
            b.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();

            handler.onSuccess(picFile.getPath());
        } catch (FileNotFoundException e) {
            handler.onError(-100, e.getMessage());
        } catch (IOException e) {
            handler.onError(-101, e.getMessage());
        }
    }
}
