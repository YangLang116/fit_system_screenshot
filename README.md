# fit_system_screenshot

让Flutter应用适配安卓系统的长截图

## 安装与卸载
1、初始化截屏库
```dart
fitSystemScreenshot.init()
```

2、卸载截屏库
```dart
fitSystemScreenshot.release()
```

## 页面初始化

1、同步Flutter层和原生层的滚动位置
```dart
screenShotDispose = fitSystemScreenshot.attachToPage(scrollAreaKey, scrollController, (offset) {
  scrollController.jumpTo(offset);
});
```

2、页面退出，释放对象
```dart
screenShotDispose?.call();
```

3、更新滚动内容长度(可选)
```dart
fitSystemScreenshot.updateScrollLength(contentLength);
```

4、更新截屏开始位置(可选)
```dart
fitSystemScreenshot.updateScrollPosition(0);
```