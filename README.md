# Lifecycle Mixin

This package allows you to manage your project using lifecycle through a Mixin. To much similar as Android's Lifecycle system and an improved implementation of [focus_detector by EdsonBueno](https://pub.dev/packages/focus_detector). 

## Features

You'll be able to manage your app with these functions:
  - onResume
  - onSuspending
  - onForegroundResume
  - onForegroundSuspending
  - onBackgroundResume
  - onBackgroundSuspending
  - onLayoutComplete

## Usage

To use this package in your `StatefulWidget`, substitute your `build()` method with `onBuild()` and use the `LifecycleMixin` available from the package.

```dart
class YourPage extends StatefulWidget {
  const YourPage({super.key});

  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> with LifecycleMixin {
  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
  }

  @override
  void onSuspending() {
    // TODO: implement onSuspending
    super.onSuspending();
  }

  @override
  void onBackgroundResume() {
    // TODO: implement onBackgroundResume
    super.onBackgroundResume();
  }

  @override
  void onBackgroundSuspending() {
    // TODO: implement onBackgroundSuspending
    super.onBackgroundSuspending();
  }

  @override
  void onForegroundResume() {
    // TODO: implement onForegroundResume
    super.onForegroundResume();
  }

  @override
  void onForegroundSuspending() {
    // TODO: implement onForegroundSuspending
    super.onForegroundSuspending();
  }

  @override
  void onLayoutComplete() {
    // TODO: implement onLayoutComplete
    super.onLayoutComplete();
  }

  @override
  Widget onBuild() {
    return Container();
  }
}
```
