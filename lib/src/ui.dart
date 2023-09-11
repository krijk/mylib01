import 'dart:math';
import 'package:flutter/material.dart';

/// My utility for user interface
class UI {
  /// Text on the scroll view
  static String text = '';

  /// Text area scroll controller
  static final ScrollController _textAreaController = ScrollController();

  /// Get the screen size
  static Size screenSize(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return size;
  }

  /// Get the screen width
  static double screenWidth(BuildContext context) {
    return screenSize(context).width;
  }

  /// Get the screen height
  static double screenHeight(BuildContext context) {
    return screenSize(context).height;
  }

  /// Check if the device is in landscape mode
  /// checked by the screen size
  static bool isLandscapeScreen(BuildContext ctx) {
    final double w = screenWidth(ctx);
    final double h = screenHeight(ctx);
    if (w > h) {
      return true;
    }
    return false;
  }

  /// Create text area
  static Widget textArea(String text, double? width, double? height) {
    UI.text = text;

    return Container(
      width: width,
      height: height,
      // Margin of the container
      margin: const EdgeInsets.all(15.0),
      // Padding: margin inside of container
      padding: const EdgeInsets.all(3.0),

      decoration: BoxDecoration(
        // adding borders around the widget
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 2.0,
        ),
      ),
      // SingleChildScrollView should be
      // wrapped in an Expanded Widget
      child: Scrollbar(
        // SingleChildScrollView contains a
        // single child which is scrollable
        child: SingleChildScrollView(
          // for Vertical scrolling
          // scrollDirection: Axis.vertical,
          controller: _textAreaController,
          child: Text(
            UI.text,
            style: const TextStyle(
              // color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              letterSpacing: 0,
              wordSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }

  /// Scroll the text area to the bottom
  static void textAreaScrollDown() {
    final ScrollController controller = _textAreaController;
    if (controller.hasClients) {
      controller.jumpTo(controller.position.maxScrollExtent);
    }
  }

  /// Get random color
  static Color getRandomColor() {
    return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  /// Get current theme data
  static ThemeData getCurrentThemeData(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }
}
