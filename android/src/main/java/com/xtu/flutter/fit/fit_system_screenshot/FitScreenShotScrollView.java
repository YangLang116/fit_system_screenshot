package com.xtu.flutter.fit.fit_system_screenshot;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;

import androidx.annotation.NonNull;

public class FitScreenShotScrollView extends ScrollView {
    private final View contentView;
    private int contentViewHeight = 0;
    private boolean needCallBack = true;
    private ScrollListener scrollViewListener;

    FitScreenShotScrollView(Context context) {
        super(context);
        setOverScrollMode(View.OVER_SCROLL_NEVER);
        setVerticalScrollBarEnabled(false);
        LinearLayout ll = new LinearLayout(context);
        ll.setOrientation(LinearLayout.VERTICAL);
        this.contentView = new View(context);
        ll.addView(this.contentView, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        addView(ll, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));
    }

    void setScrollViewListener(@NonNull ScrollListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldL, int oldT) {
        super.onScrollChanged(l, t, oldL, oldT);
        if (scrollViewListener != null && needCallBack) scrollViewListener.onScroll(t);
    }

    void updateScrollLength(double scrollHeight) {
        if (this.contentViewHeight == scrollHeight) return;
        this.contentViewHeight = (int) scrollHeight;
        ViewGroup.LayoutParams layoutParams = contentView.getLayoutParams();
        layoutParams.height = this.contentViewHeight;
        this.contentView.setLayoutParams(layoutParams);
    }

    void scrollToWithoutCallback(int position) {
        this.needCallBack = false;
        scrollTo(0, position);
        this.needCallBack = true;
    }

    public interface ScrollListener {
        void onScroll(double top);
    }
}