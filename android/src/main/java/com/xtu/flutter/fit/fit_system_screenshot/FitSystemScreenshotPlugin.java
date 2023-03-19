package com.xtu.flutter.fit.fit_system_screenshot;

import android.app.Activity;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/**
 * FitSystemScreenshotPlugin
 */
public class FitSystemScreenshotPlugin implements FlutterPlugin, ActivityAware {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        FitScreenShotHelper.getInstance().attachToEngine(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FitScreenShotHelper.getInstance().detachToEngine();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Activity activity = binding.getActivity();
        FitScreenShotHelper.getInstance().install(activity);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
