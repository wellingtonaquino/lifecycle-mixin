library lifecycle_mixin;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'lifecycle_background_handler.dart';

mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  //Private Variables
  bool _isWidgetVisible = false;
  bool _isAppInForeground = true;
  late LifecycleBackgroundHandler _lifecycleBackgroundHandler;
  String screenName = '';

  //Functions to Extend
  void onResume() {}
  void onSuspending() {}

  void onForegroundResume() {}
  void onForegroundSuspending() {}

  void onBackgroundResume() {}
  void onBackgroundSuspending() {}

  void onLayoutComplete() {}

  void setName(String name) {
    screenName = name;
  }

  Widget onBuild() => const SizedBox.shrink();

  //Inheritance Functions
  @override
  void initState() {
    debugPrint('Lifecycle $screenName: InitState');
    _lifecycleBackgroundHandler = LifecycleBackgroundHandler(
      onResume: onResume,
      onSuspending: onSuspending,
      onBackgroundResume: onBackgroundResume,
      onBackgroundSuspending: onBackgroundSuspending,
      getIsWidgetVisible: () => _isWidgetVisible,
      getIsAppInForeground: () => _isAppInForeground,
      changeIsAppInForeground: (isAppInForeground) {
        _isAppInForeground = isAppInForeground;
      },
      getScreenName: () => screenName,
    );
    WidgetsBinding.instance.addObserver(_lifecycleBackgroundHandler);

    super.initState();

    VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 250);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('Lifecycle $screenName: onLayoutComplete');
      onLayoutComplete();
    });
  }

  @override
  void dispose() {
    debugPrint('Lifecycle $screenName: OnDispose');
    WidgetsBinding.instance.removeObserver(_lifecycleBackgroundHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (visibilityInfo) {
        final visibleFraction = visibilityInfo.visibleFraction;
        _notifyVisibilityStatusChange(visibleFraction);
      },
      child: onBuild(),
    );
  }

  //Private Functions
  void _notifyVisibilityStatusChange(double newVisibleFraction) {
    if (!_isAppInForeground) {
      return;
    }

    final wasFullyVisible = _isWidgetVisible;
    final isFullyVisible = newVisibleFraction == 1;

    if (!wasFullyVisible && isFullyVisible) {
      debugPrint('Lifecycle $screenName: Foreground OnResume');
      _isWidgetVisible = true;
      onResume();
      onForegroundResume();
      return;
    }

    final isFullyInvisible = newVisibleFraction == 0;

    if (wasFullyVisible && isFullyInvisible) {
      debugPrint('Lifecycle $screenName: Foreground OnSuspending');
      _isWidgetVisible = false;
      onSuspending();
      onForegroundSuspending();
    }
  }
}
