package com.xtu.flutter.fit.fit_system_screenshot;

import android.app.Activity;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/**
 * FitSystemScreenshotPlugin
 */
public class FitSystemScreenshotPlugin implements FlutterPlugin, ActivityAware {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        BinaryMessenger binaryMessenger = binding.getBinaryMessenger();
        FitScreenShotManager.getInstance().attachToEngine(binaryMessenger);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        FitScreenShotManager.getInstance().detachFromEngine();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Activity activity = binding.getActivity();
        FitScreenShotManager.getInstance().attachToActivity(activity);
    }


    @Override
    public void onDetachedFromActivity() {
        FitScreenShotManager.getInstance().detachFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }
}
