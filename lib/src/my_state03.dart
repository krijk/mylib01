import 'package:flutter/material.dart';
import 'ui.dart';

/// My main widget
abstract class MyMainWidget03 extends StatefulWidget {
  /// My main widget
  const MyMainWidget03(this.title);

  /// main widget title
  final String title;
}

/// My stateful state base
@optionalTypeArgs
class MyWidgetStateBase03 extends State<MyMainWidget03> {
  /// state progress message
  String text = '';

  Widget _portraitMode(BuildContext context) {
    final double width = UI.screenWidth(context);
    final double height = UI.screenHeight(context);
    const double paramWidth = 0.9;
    const double paramHeight = 0.75;
    return Scrollbar(
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: UI.textArea(text, width * paramWidth, height * paramHeight),
            ),
            controlsHorizontal(context),
          ],
        ),
      ),
    );
  }

  Widget _landscapeMode(BuildContext context) {
    final double height = UI.screenHeight(context);
    const double paramWidth = 0.9;
    const double paramHeight = 0.6;
    return Row(
      children: <Widget>[
        Expanded(
          child: UI.textArea(text, height * paramWidth, height * paramHeight),
        ),
        controlsVertical(context),
      ],
    );
  }

  /// append message
  void append(String tx) {
    setState(() {
      text += '\n$tx';
    });
  }

  /// add a log line
  void addLog(dynamic msg) {
    final String line = '${DateTime.now().toString().substring(11)}${', $msg'}';
    append(line);
  }

  /// line feed
  void newline() {
    append('\n');
  }

  /// Clear log
  void clearLog() {
    text = '';
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.portrait) {
          return _portraitMode(context);
        } else {
          return _landscapeMode(context);
        }
      },
    );
  }

  /// Test function
  void onTest01() {}

  /// Test function
  void onTest02() {}

  /// Control area
  Widget controlsHorizontal(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back'),
        ),
        ElevatedButton(
          onPressed: () => onTest01(),
          child: const Text('Test1'),
        ),
        ElevatedButton(
          onPressed: () => onTest02(),
          child: const Text('Test2'),
        ),
      ],
    );
  }

  /// Control area
  Widget controlsVertical(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back'),
        ),
        ElevatedButton(
          onPressed: () => onTest01(),
          child: const Text('Test1'),
        ),
        ElevatedButton(
          onPressed: () => onTest02(),
          child: const Text('Test2'),
        ),
      ],
    );
  }
}
