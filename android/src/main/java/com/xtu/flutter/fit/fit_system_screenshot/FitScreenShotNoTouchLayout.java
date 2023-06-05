package com.xtu.flutter.fit.fit_system_screenshot;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.MotionEvent;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

public class FitScreenShotNoTouchLayout extends FrameLayout {

    FitScreenShotNoTouchLayout(@NonNull Context context) {
        super(context);
    }

    @Override
    @SuppressLint("ClickableViewAccessibility")
    public boolean onTouchEvent(MotionEvent event) {
        return false;
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (ev.getToolType(0) == MotionEvent.TOOL_TYPE_FINGER) {
            return false;
        }
        return super.dispatchTouchEvent(ev);
    }
}
