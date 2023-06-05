package com.xtu.flutter.fit.fit_system_screenshot;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class FitScreenShotManager {

    private static final String TAG = "FitScreenShotManager";
    private static final String METHOD_CHANNEL_NAME = "fit.system.screenshot.method";
    private static final String EVENT_CHANNEL_NAME = "fit.system.screenshot.event";

    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;
    private FitScreenShotScrollView scrollView;
    private FitScreenShotNoTouchLayout touchParentView;
    private static final FitScreenShotManager sInstance = new FitScreenShotManager();

    static FitScreenShotManager getInstance() {
        return sInstance;
    }

    @SuppressWarnings({"ConstantConditions", "unchecked"})
    void attachToEngine(@NonNull BinaryMessenger messenger) {
        Log.d(TAG, "attachToEngine");
        this.methodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        this.methodChannel.setMethodCallHandler((call, result) -> {
            String methodName = call.method;
            if (TextUtils.equals("updateScrollArea", methodName) && this.touchParentView != null) {
                final Map<String, Integer> args = (Map<String, Integer>) call.arguments;
                Log.d(TAG, "updateScrollArea args: " + args);
                ViewGroup.MarginLayoutParams layoutParams = (ViewGroup.MarginLayoutParams) this.touchParentView.getLayoutParams();
                layoutParams.leftMargin = args.get("left");
                layoutParams.topMargin = args.get("top");
                layoutParams.width = args.get("width");
                layoutParams.height = args.get("height");
                this.touchParentView.setLayoutParams(layoutParams);
                result.success(true);
            } else if (TextUtils.equals("updateScrollLength", methodName) && this.scrollView != null) {
                final Map<String, Double> args = (Map<String, Double>) call.arguments;
                Log.d(TAG, "updateScrollLength args: " + args);
                double length = args.get("length");
                this.scrollView.updateScrollLength(length);
                result.success(true);
            } else if (TextUtils.equals("updateScrollPosition", methodName) && this.scrollView != null) {
                final Map<String, Double> args = (Map<String, Double>) call.arguments;
                Log.d(TAG, "updateScrollPosition args: " + args);
                int position = (int) Math.ceil(args.get("position"));
                this.scrollView.post(() -> scrollView.scrollToWithoutCallback(position));
                result.success(true);
            }
        });
        this.eventChannel = new EventChannel(messenger, EVENT_CHANNEL_NAME);
        this.eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink sink) {
                Log.d(TAG, "EventChannel onListen");
                eventSink = sink;
            }

            @Override
            public void onCancel(Object arguments) {
                Log.d(TAG, "EventChannel onCancel");
            }
        });
    }

    void detachFromEngine() {
        Log.d(TAG, "detachFromEngine");
        this.methodChannel.setMethodCallHandler(null);
        this.eventChannel.setStreamHandler(null);
        this.eventSink.endOfStream();
    }

    @SuppressLint("ClickableViewAccessibility")
    void attachToActivity(@NonNull Activity activity) {
        Log.d(TAG, "attachToActivity");
        this.scrollView = new FitScreenShotScrollView(activity);
        final Map<String, Double> params = new HashMap<>();
        this.scrollView.setScrollViewListener((top) -> {
            if (this.eventSink == null) return;
            params.put("top", top);
            this.eventSink.success(params);
        });
        this.touchParentView = new FitScreenShotNoTouchLayout(activity);
        this.touchParentView.addView(this.scrollView,
                new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        ViewGroup decorView = ((ViewGroup) activity.getWindow().getDecorView());
        decorView.addView(this.touchParentView,
                new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
    }

    void detachFromActivity() {
        Log.d(TAG, "detachFromActivity");
    }

}
