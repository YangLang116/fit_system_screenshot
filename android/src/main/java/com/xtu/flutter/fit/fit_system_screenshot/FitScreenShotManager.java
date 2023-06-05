package com.xtu.flutter.fit.fit_system_screenshot;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
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
    private FitScreenShotScrollView scrollView;
    private FitScreenShotNoTouchLayout touchParentView;
    private View flutterView;

    private static final FitScreenShotHelper sInstance = new FitScreenShotHelper();
    private ViewGroup decorView;

    public static FitScreenShotHelper getInstance() {
        return sInstance;
    }

    @SuppressLint("ClickableViewAccessibility")
    public void install(@NonNull Activity activity) {
        Log.d(TAG, "install");
        decorView = ((ViewGroup) activity.getWindow().getDecorView());
        this.scrollView = new FitScreenShotScrollView(activity);
        final Map<String, Double> params = new HashMap<>();
        scrollView.setScrollViewListener((top) -> {
//            if (!touchParentView.isScreenShotMode) return;
            if (this.eventSink == null) return;
            params.put("top", top);
            this.eventSink.success(params);
        });
        //小米
//        scrollView.setOnTouchListener((v, event) -> {
//            int actionMasked = event.getActionMasked();
//            if (actionMasked != MotionEvent.ACTION_DOWN
//                    && actionMasked != MotionEvent.ACTION_MOVE
//                    && actionMasked != MotionEvent.ACTION_UP
//                    && actionMasked != MotionEvent.ACTION_CANCEL)
//                return false;
//
//
//            Log.d(TAG, "ACTION: " + event.getActionMasked() + " Y: " + event.getY());
//            Log.d(TAG, "SCROLL: " + scrollView.getScrollY());
//
//            if (flutterView == null) {
//                flutterView = decorView.findViewById(FlutterActivity.FLUTTER_VIEW_ID);
////            ViewGroup contentView = decorView.findViewById(Window.ID_ANDROID_CONTENT)
//            }
//            //转化手势
//            MotionEvent.PointerProperties pointerProperties = new MotionEvent.PointerProperties();
//            pointerProperties.id = 0;
//            pointerProperties.toolType = MotionEvent.TOOL_TYPE_FINGER;
//
//            MotionEvent.PointerCoords pointerLocation = new MotionEvent.PointerCoords();
//            pointerLocation.orientation = event.getOrientation();
//            pointerLocation.size = event.getSize();
//            pointerLocation.pressure = event.getPressure();
//            pointerLocation.toolMajor = event.getToolMajor();
//            pointerLocation.toolMinor = event.getToolMinor();
//            pointerLocation.touchMajor = event.getTouchMajor();
//            pointerLocation.touchMinor = event.getTouchMinor();
//            pointerLocation.x = event.getX();
//            pointerLocation.y = event.getY();
//
//            MotionEvent newEvent = MotionEvent.obtain(
//                    event.getDownTime(),
//                    event.getEventTime(),
//                    event.getAction(),
//                    event.getPointerCount(),
//                    new MotionEvent.PointerProperties[]{pointerProperties},
//                    new MotionEvent.PointerCoords[]{pointerLocation},
//                    event.getMetaState(), event.getButtonState(), event.getXPrecision(), event.getYPrecision(),
//                    event.getDeviceId(), event.getEdgeFlags(), event.getSource(), event.getFlags());
//
//            flutterView.onTouchEvent(newEvent);
//            return false;
//        });
        //禁用触摸事件
        this.touchParentView = new FitScreenShotNoTouchLayout(activity);
        this.touchParentView.addView(this.scrollView, getLayoutParams());
        decorView.addView(this.touchParentView, getLayoutParams());
    }

    @SuppressWarnings({"ConstantConditions", "unchecked"})
    public void attachToEngine(@NonNull BinaryMessenger messenger) {
        Log.d(TAG, "attachToEngine");
        this.methodChannel = new MethodChannel(messenger, METHOD_CHANNEL_NAME);
        this.methodChannel.setMethodCallHandler((call, result) -> {
            String methodName = call.method;
            Log.d(TAG, "onMethodCall: " + methodName);
            if (TextUtils.equals("updateScrollArea", methodName)
                    && this.touchParentView != null) {
                final Map<String, Integer> args = (Map<String, Integer>) call.arguments;
                FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) this.touchParentView.getLayoutParams();
                int top = args.get("top");
                int left = args.get("left");
//                int width = args.get("width");
//                int height = args.get("height");
                layoutParams.topMargin = top;
                layoutParams.leftMargin = left;


//                DisplayMetrics displayMetrics = Resources.getSystem().getDisplayMetrics();
//                int screenWidth = displayMetrics.widthPixels;
//                int screenHeight = displayMetrics.heightPixels;
//                View contentView = this.decorView.findViewById(Window.ID_ANDROID_CONTENT);
//                layoutParams.rightMargin = contentView.getMeasuredWidth() - left - width;
//                layoutParams.bottomMargin = contentView.getMeasuredHeight() - top - height;

                layoutParams.width = args.get("width");
                layoutParams.height = args.get("height");
                this.touchParentView.setLayoutParams(layoutParams);
                result.success(true);
            } else if (TextUtils.equals("updateScrollLength", methodName)
                    && this.scrollView != null) {
                final Map<String, Double> args = (Map<String, Double>) call.arguments;
                double maxLength = args.get("length");
                Log.d(TAG, "updateScrollLength length: " + maxLength);
                this.scrollView.updateScrollLength(maxLength);
                result.success(true);
            } else if (TextUtils.equals("updateScrollPosition", methodName)
                    && this.scrollView != null
                    && this.touchParentView != null) {
//                    && !this.touchParentView.isScreenShotMode) {
                final Map<String, Double> args = (Map<String, Double>) call.arguments;
                int position = (int) Math.ceil(args.get("position"));
                Log.d(TAG, "updatePosition position: " + position);
                this.scrollView.post(() -> scrollView.scrollToWithoutCallback(position));
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
