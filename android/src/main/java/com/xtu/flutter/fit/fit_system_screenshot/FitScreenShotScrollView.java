package com.xtu.flutter.fit.fit_system_screenshot;

import android.content.Context;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ScrollView;
import android.widget.TextView;

public class FitScreenShotScrollView extends ScrollView {

    private static final String TAG = "FitScreenShotScrollView";

    private int currentLength;
    private final TextView contentView;
    private ScrollListener scrollViewListener;

    public FitScreenShotScrollView(Context context) {
        super(context);
        setOverScrollMode(View.OVER_SCROLL_NEVER);
        setVerticalScrollBarEnabled(false);
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        int screenWidth = displayMetrics.widthPixels;
        int screenHeight = displayMetrics.heightPixels;
        this.contentView = new TextView(context);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 500; i++) {
            sb.append("item " + i).append("\n");
        }
        this.contentView.setText(sb.toString());
        this.contentView.setWidth(screenWidth);
        this.contentView.setHeight(this.currentLength = screenHeight); //让控件支持滑动
        addView(contentView);
    }

    public void setScrollViewListener(ScrollListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        Log.d(TAG, "onTouchEvent: " + ev);
        return super.onTouchEvent(ev);
    }

    @Override
    public void scrollTo(int x, int y) {
        Log.d(TAG, "scrollTo: " + y);
        super.scrollTo(x, y);
    }

    @Override
    public void scrollBy(int x, int y) {
        Log.d(TAG, "scrollBy: " + y);
        super.scrollBy(x, y);
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldL, int oldT) {
        super.onScrollChanged(l, t, oldL, oldT);
        if (scrollViewListener != null) scrollViewListener.onScroll(t);
    }

    public void updateScrollLength(double maxLength) {
        if (this.currentLength == maxLength) return;
        this.contentView.setHeight(this.currentLength = (int) maxLength);
    }

    public interface ScrollListener {
        void onScroll(double top);
    }
}