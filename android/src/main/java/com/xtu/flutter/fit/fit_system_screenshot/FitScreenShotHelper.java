package com.xtu.flutter.fit.fit_system_screenshot;

import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class FitScreenShotHelper {

    private static final String TAG = "FitScreenShotHelper";
    private static final String METHOD_CHANNEL_NAME = "fit.system.screenshot.method";
    private static final String EVENT_CHANNEL_NAME = "fit.system.screenshot.event";

    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
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
            if (this.eventSink == null) return;
            params.put("delta", delta);
            this.eventSink.success(params);
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
                result.success(true);
            }
        });
        this.eventChannel = new EventChannel(messenger, EVENT_CHANNEL_NAME);
        this.eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink sink) {
                Log.d(TAG, "setStreamHandler onListen");
                eventSink = sink;
            }

            @Override
            public void onCancel(Object arguments) {
                Log.d(TAG, "setStreamHandler onCancel");
            }
        });
    }

    public void detachToEngine() {
        Log.d(TAG, "detachToEngine");
        this.methodChannel.setMethodCallHandler(null);
        this.eventChannel.setStreamHandler(null);
        this.eventSink.endOfStream();
    }

    private static FrameLayout.LayoutParams getLayoutParams() {
        return new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
    }

}
