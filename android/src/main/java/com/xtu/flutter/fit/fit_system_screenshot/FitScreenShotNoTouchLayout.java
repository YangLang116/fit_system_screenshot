package com.xtu.flutter.fit.fit_system_screenshot;

import android.content.Context;
import android.view.MotionEvent;
import android.view.View;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;

public class FitScreenShotNoTouchLayout extends FrameLayout {
    public FitScreenShotNoTouchLayout(@NonNull Context context) {
        super(context);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return false;
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        int toolType = ev.getToolType(0);
        if (toolType != MotionEvent.TOOL_TYPE_FINGER) {
            return super.dispatchTouchEvent(ev);
        }
        if (ev.getActionMasked() == MotionEvent.ACTION_DOWN) {
            View scrollView = getChildAt(0);
            if (scrollView instanceof FitScreenShotScrollView) scrollView.scrollTo(0, 0);
        }
        return false;
    }
}
