package com.xtu.flutter.fit.fit_system_screenshot;

import android.content.Context;
import android.util.DisplayMetrics;
import android.widget.ScrollView;
import android.widget.TextView;

public class FitScreenShotScrollView extends ScrollView {

    private ScrollListener scrollViewListener;

    public FitScreenShotScrollView(Context context) {
        super(context);
        setVerticalScrollBarEnabled(false);
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        int screenWidth = displayMetrics.widthPixels;
        int screenHeight = displayMetrics.heightPixels;
        TextView contentView = new TextView(context);
        contentView.setWidth(screenWidth);
        contentView.setHeight(screenHeight * 10); //让控件支持滑动
        addView(contentView);
    }

    public void setScrollViewListener(ScrollListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldL, int oldT) {
        super.onScrollChanged(l, t, oldL, oldT);
        if (scrollViewListener != null && t - oldT > 0) {
            scrollViewListener.onScroll(t - oldT);
        }
    }

    public interface ScrollListener {
        void onScroll(double delta);
    }
}