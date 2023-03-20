package com.xtu.flutter.fit.fit_system_screenshot;

import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.FrameLayout;
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
    private ViewGroup noTouchLayout;

    private static final FitScreenShotHelper sInstance = new FitScreenShotHelper();

    public static FitScreenShotHelper getInstance() {
        return sInstance;
    }

    public void install(@NonNull Activity activity) {
        Log.d(TAG, "install");
        FitScreenShotScrollView scrollView = new FitScreenShotScrollView(activity);
        final Map<String, Double> params = new HashMap<>();
        scrollView.setScrollViewListener((delta) -> {
            if (this.methodChannel == null) return;
            params.put("delta", delta);
            this.methodChannel.invokeMethod("scroll", params, this);
        });
        Window window = activity.getWindow();
        ViewGroup decorView = ((ViewGroup) window.getDecorView());
        //禁用触摸事件
        this.noTouchLayout = new FitScreenShotNoTouchLayout(activity);
        this.noTouchLayout.addView(scrollView, getLayoutParams());
        decorView.addView(noTouchLayout, getLayoutParams());
    }

    @SuppressWarnings({"ConstantConditions", "unchecked"})
    public void attachToEngine(@NonNull BinaryMessenger messenger) {
        Log.d(TAG, "attachToEngine");
        this.methodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        this.methodChannel.setMethodCallHandler((call, result) -> {
            if (this.noTouchLayout == null) return;
            String methodName = call.method;
            Log.d(TAG, "onMethodCall: " + methodName);
            if (TextUtils.equals("updateScrollArea", methodName)) {
                final Map<String, Integer> args = (Map<String, Integer>) call.arguments;
                FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) noTouchLayout.getLayoutParams();
                layoutParams.topMargin = args.get("top");
                layoutParams.leftMargin = args.get("left");
                layoutParams.width = args.get("width");
                layoutParams.height = args.get("height");
                noTouchLayout.setLayoutParams(layoutParams);
            }
        });
    }

    public void detachToEngine() {
        Log.d(TAG, "detachToEngine");
        this.methodChannel.setMethodCallHandler(null);
    }

    private static FrameLayout.LayoutParams getLayoutParams() {
        return new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
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
