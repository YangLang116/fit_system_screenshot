# fit_system_screenshot

让Flutter应用适配安卓系统的长截图

## 基础使用(参考Demo中的Basic Usage)

1、在需要支持长截屏的页面设置 `scrollController` ，保证系统在截屏时自动滚动内容
```dart
  screenShotHelper.attach(scrollController);
```

2、指定滚动区域
```dart
  fitSystemScreenshot.updateScrollArea(render.rect);
```

3、当支持长截屏的页面退出时，释放对象
```dart
  screenShotHelper.detach();
```


## 高级使用(参考Demo中的 FitSystemScreenshotWidget Usage)
```dart
  @override
  Widget build(BuildContext context) {
    //...
    return Scaffold(
      appBar: AppBar(title: Text('FitSystemScreenshotWidget Usage')),
      //1、使用FitSystemScreenshotWidget包裹滚动控件
      body: FitSystemScreenshotWidget(
        key: screenShotKey,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
  
  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) { //2、当前页面可见时调用
      //等待Element树构建
      Future.delayed(Duration.zero, () {
        FitSystemScreenshotWidgetState? currentState =
            screenShotKey.currentState;
        if (currentState == null) return;
        currentState.attach();
      });
    } else if (event == LifecycleEvent.inactive) { //3、当前页面不可见时调用
      FitSystemScreenshotWidgetState? currentState = screenShotKey.currentState;
      if (currentState == null) return;
      currentState.detach();
    }
  }
```