library;
import 'package:flutter/material.dart';

/// Flutter: how to force an application restart (in production mode)?
/// https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode

/// Restart widget
class RestartWidget extends StatefulWidget {
  /// Restart widget
  const RestartWidget({required this.child});

  /// The widget to restart
  final Widget child;

  /// Do restart
  static void restartApp(BuildContext context) {

    final State<RestartWidget>? state = context.findRootAncestorStateOfType<State<RestartWidget>>();
    if (state is RestartWidgetState) {
      state.restartApp();
    }
  }

  @override
  RestartWidgetState createState() => RestartWidgetState();
}

///
class RestartWidgetState extends State<RestartWidget> {
  ///
  Key key = UniqueKey();

  /// Restart application
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
