package com.yunzhu.glossexample;

import android.app.NativeActivity;

public class YzNativeActivity extends NativeActivity {
    static {
      System.loadLibrary("gloss-example");
    }
}
