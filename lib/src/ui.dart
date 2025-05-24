import 'dart:math';
import 'package:flutter/material.dart';

/// My utility for user interface
class UI {
  /// font size
  static const double defaultFontSize = 14.0;
  /// Text area margin
  static const double defaultMarginValue = 15.0;
  /// Text area padding
  static const double defaultPaddingValue = 3.0;
  /// Text area border width
  static const double defaultBorderWidth = 2.0;

  /// Get the screen size
  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
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
    final Size size = screenSize(ctx);
    return size.width > size.height;
  }

  /// Create text area
  static Widget textArea(
    String text, {
    double? width,
    double? height,
    TextStyle? style,
    ScrollController? scrollController, // Allow passing a controller
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    style ??= const TextStyle(
      // color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: defaultFontSize,
      letterSpacing: 0,
      wordSpacing: 0,
    );

    return Container(
      width: width,
      height: height,
      // Margin of the container
      margin: margin ?? const EdgeInsets.all(defaultMarginValue),
      // Padding: margin inside of container
      padding: padding ?? const EdgeInsets.all(defaultPaddingValue),

      decoration: BoxDecoration(
        // adding borders around the widget
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: defaultBorderWidth,
        ),
      ),
      // SingleChildScrollView should be
      // wrapped in an Expanded Widget
      child: Scrollbar(
        // SingleChildScrollView contains a
        // single child which is scrollable
        controller: scrollController,
        child: SingleChildScrollView(
          // for Vertical scrolling
          // scrollDirection: Axis.vertical,
          controller: scrollController,
          child: Padding( // Add padding around text for better aesthetics
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: style,
            ),
          ),
        ),
      ),
    );
  }

  /// Scroll the text area to the bottom
  // static void textAreaScrollDown() {
  //   final ScrollController controller = _textAreaController;
  //   if (controller.hasClients) {
  //     controller.jumpTo(controller.position.maxScrollExtent);
  //   }
  // }

  /// Get random color
  static Color getRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // Red
      random.nextInt(256), // Green
      random.nextInt(256), // Blue
      1.0, // Opacity
    );
  }

  /// Get current theme data
  static ThemeData getCurrentThemeData(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }
}
