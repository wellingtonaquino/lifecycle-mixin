import 'package:flutter/material.dart';

class LifecycleBackgroundHandler extends WidgetsBindingObserver {
  final VoidCallback onResume;
  final VoidCallback onSuspending;
  final VoidCallback onBackgroundResume;
  final VoidCallback onBackgroundSuspending;
  final bool Function() getIsWidgetVisible;
  final bool Function() getIsAppInForeground;
  final void Function(bool isAppInForeground) changeIsAppInForeground;

  final String Function() getScreenName;

  LifecycleBackgroundHandler({
    required this.onResume,
    required this.onSuspending,
    required this.onBackgroundResume,
    required this.onBackgroundSuspending,
    required this.getIsWidgetVisible,
    required this.getIsAppInForeground,
    required this.changeIsAppInForeground,
    required this.getScreenName,
  });

  //Inheritance Functions
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _notifyPlaneTransition(state);
  }

  void _notifyPlaneTransition(AppLifecycleState state) {
    if (!getIsWidgetVisible()) {
      return;
    }

    final screenName = getScreenName();

    final wasResumed = getIsAppInForeground.call();
    final isAppResumed = state == AppLifecycleState.resumed;

    if (!wasResumed && isAppResumed) {
      debugPrint('Lifecycle $screenName: Background OnResume');
      changeIsAppInForeground.call(true);
      onResume();
      onBackgroundResume();
      return;
    }

    final isAppPaused = state == AppLifecycleState.paused;

    if (wasResumed && isAppPaused) {
      debugPrint('Lifecycle $screenName: Background OnSuspending');
      changeIsAppInForeground.call(false);
      onSuspending();
      onBackgroundSuspending();
    }
  }
}
