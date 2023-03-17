package com.xtu.flutter.fit.fit_system_screenshot;

import android.app.Activity;
import android.util.Log;
import android.view.ViewGroup;
import android.view.Window;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

import java.util.HashMap;
import java.util.Map;

public class FitScreenShotHelper implements MethodChannel.Result {

    private static final String TAG = "FitScreenShotHelper";
    private static final String METHOD_CHANNEL_NAME = "fit.system.screenshot";

    private MethodChannel methodChannel;
    private static final FitScreenShotHelper sInstance = new FitScreenShotHelper();

    public static FitScreenShotHelper getInstance() {
        return sInstance;
    }

    public void install(@NonNull Activity activity) {
        Log.d(TAG, "install");
        FitScreenShotScrollView scrollView = new com.xtu.flutter.fit.fit_system_screenshot.FitScreenShotScrollView(activity);
        Map<String, Double> params = new HashMap<>();
        scrollView.setScrollViewListener((delta) -> {
            if (methodChannel == null) return;
            params.put("delta", delta);
            methodChannel.invokeMethod("scroll", params, this);
        });
        Window window = activity.getWindow();
        ViewGroup decorView = ((ViewGroup) window.getDecorView());
        //禁用触摸事件
        FitScreenShotNoTouchLayout noTouchLayout = new FitScreenShotNoTouchLayout(activity);
        noTouchLayout.addView(scrollView, getLayoutParams());
        decorView.addView(noTouchLayout, getLayoutParams());
    }

    public void attachToEngine(@NonNull BinaryMessenger messenger) {
        Log.d(TAG, "attachToEngine");
        this.methodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
    }

    private static ViewGroup.LayoutParams getLayoutParams() {
        return new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
    }

    @Override
    public void success(@Nullable Object o) {
        Log.d(TAG, String.format("MethodChannel success: %s", o));
    }

    @Override
    public void error(String s, @Nullable String s1, @Nullable Object o) {
        Log.d(TAG, String.format("MethodChannel error: %s %s", s, s1));
    }

    @Override
    public void notImplemented() {
        Log.d(TAG, "MethodChannel notImplemented");
    }
}
