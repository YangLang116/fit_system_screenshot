package com.xtu.flutter.fit.fit_system_screenshot;

import android.content.Context;
import android.util.DisplayMetrics;
import android.view.MotionEvent;
import android.widget.ScrollView;
import android.widget.TextView;

public class FitScreenShotScrollView extends ScrollView {

    private final int screenHeight;
    private ScrollListener scrollViewListener;

    public FitScreenShotScrollView(Context context) {
        super(context);
        setVerticalScrollBarEnabled(false);
        DisplayMetrics displayMetrics = getResources().getDisplayMetrics();
        int screenWidth = displayMetrics.widthPixels;
        screenHeight = displayMetrics.heightPixels;
        TextView contentView = new TextView(context);
        contentView.setWidth(screenWidth);
        //让控件支持滑动
        contentView.setHeight(screenHeight * 10);
        addView(contentView);
    }

    public void setScrollViewListener(ScrollListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        if (ev.getAction() == MotionEvent.ACTION_DOWN) {
            scrollTo(0, 0);
        }
        return super.onTouchEvent(ev);
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldL, int oldT) {
        super.onScrollChanged(l, t, oldL, oldT);
        //判断是否下滑 && 防止跳跃(oldT > 0)
        if (scrollViewListener != null && t - oldT > 0 && oldT > 0) {
            //0.25(滑动阻尼系数)解决原生与Flutter滑动不同步问题
            scrollViewListener.onScroll(t - oldT);
        }
        //无限滑动
        fixScrollPosition(t);
    }

    private void fixScrollPosition(int t) {
        if (t >= screenHeight * 8.5) scrollTo(0, 0);
    }

    public interface ScrollListener {
        void onScroll(double delta);
    }
}