# fit_system_screenshot

让Flutter应用适配安卓系统的长截图

## 使用

1、在需要支持长截屏的页面设置 `scrollController` ，保证系统在截屏时自动滚动内容
```dart
  screenShotHelper.attach(scrollController);
```

2、指定滚动区域
```dart
  AfterLayout(
    callback: (render) {
      fitSystemScreenshot.updateScrollArea(render.rect);
    },
    child: ListView.builder(...)
  )
```

3、当支持长截屏的页面退出时，释放对象
```dart
screenShotHelper.detach();
```

