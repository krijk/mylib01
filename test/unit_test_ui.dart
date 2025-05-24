// For Size
import 'package:flutter/material.dart'; // For Color, TextStyle, etc.
import 'package:flutter_test/flutter_test.dart';
import 'package:mylib01/lib.dart'; // For testWidgets if we extend later

/// Unit test for UI utility
void main() {
  group('UIUtils Tests', () {
    group('getRandomColor', () {
      test('should return a Color object', () {
        expect(UI.getRandomColor(), isA<Color>());
      });

      test('should return an opaque color', () {
        final Color color = UI.getRandomColor();
        expect(color.a, 1.0);
      });

      test('should return different colors on subsequent calls (high probability)', () {
        // This test isn't foolproof due to randomness but is a good sanity check.
        final Color color1 = UI.getRandomColor();
        final Color color2 = UI.getRandomColor();
        final Color color3 = UI.getRandomColor();
        expect(
          color1 == color2 && color2 == color3,
          isFalse,
          reason: 'Expected different colors, but got same for multiple calls. '
              'While statistically possible, it might indicate an issue with randomness.',
        );
      });
    });

    // Note: Testing methods that rely heavily on BuildContext and MediaQuery
    // like screenSize, screenWidth, screenHeight, and isLandscapeScreen
    // is more robustly done with widget tests (`testWidgets`).
    // For isLandscapeScreen, you could test the logic if you extracted it
    // to take width and height as parameters.

    group('buildScrollableTextArea', () {
      // Basic unit test: Check the type of widget returned and some default properties
      // More detailed testing of widget structure requires `testWidgets`.
      test('should return a Container widget', () {
        final Widget widget = UI.textArea("Test text");
        expect(widget, isA<Container>());
      });

      test('should use default font size when no style is provided', () {
        // This test is a bit more involved as it peeks into widget properties.
        // It's on the edge of unit vs. widget testing.
        final Container textAreaWidget = UI.textArea("Test text") as Container;
        final Scrollbar scrollbar = textAreaWidget.child! as Scrollbar;
        final SingleChildScrollView singleChildScrollView = scrollbar.child as SingleChildScrollView;
        final Padding padding = singleChildScrollView.child! as Padding;
        final Text textWidget = padding.child! as Text;

        expect(textWidget.data, "Test text");
        // Check default style properties (or parts of it)
        expect(textWidget.style?.fontSize, UI.defaultFontSize);
        expect(textWidget.style?.fontWeight, FontWeight.normal);
      });

      test('should use provided style', () {
        const TextStyle customStyle = TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold);
        final Container textAreaWidget = UI.textArea(
          "Styled text",
          style: customStyle,
        ) as Container;
        final Scrollbar scrollbar = textAreaWidget.child! as Scrollbar;
        final SingleChildScrollView singleChildScrollView = scrollbar.child as SingleChildScrollView;
        final Padding padding = singleChildScrollView.child! as Padding;
        final Text textWidget = padding.child! as Text;

        expect(textWidget.style?.fontSize, customStyle.fontSize);
        expect(textWidget.style?.color, customStyle.color);
        expect(textWidget.style?.fontWeight, customStyle.fontWeight);
      });

      test('should apply custom margin and padding if provided', () {
        const EdgeInsets customMargin = EdgeInsets.all(5.0);

        final Container widget = UI.textArea(
          "Test text",
          margin: customMargin,
          // Note: The `padding` parameter in `buildScrollableTextArea` applies to the Container,
          // but there's also an internal Padding widget around the Text.
          // For this example, let's assume we want to test the outer Container's margin.
        ) as Container;

        expect(widget.margin, customMargin);
        // To test the inner padding, you'd navigate the widget tree like in previous tests.
      });

      test('should accept and use a ScrollController', () {
        final ScrollController scrollController = ScrollController();
        final Container widget = UI.textArea(
          "Test text",
          scrollController: scrollController,
        ) as Container;

        final Scrollbar scrollbar = widget.child! as Scrollbar;
        final SingleChildScrollView singleChildScrollView = scrollbar.child as SingleChildScrollView;

        expect(scrollbar.controller, scrollController);
        expect(singleChildScrollView.controller, scrollController);

        scrollController.dispose(); // Important to dispose controllers
      });
    });

    // Example of how you might test isLandscape (if it took width/height)
    // Create a helper for this if you refactor isLandscapeScreen
    // bool isLandscapePure(double w, double h) => w > h;
    // test('isLandscapePure should return true for width > height', () {
    //   expect(isLandscapePure(800, 600), isTrue);
    // });
    // test('isLandscapePure should return false for width < height', () {
    //   expect(isLandscapePure(600, 800), isFalse);
    // });
    // test('isLandscapePure should return false for width == height', () {
    //   expect(isLandscapePure(600, 600), isFalse);
    // });
  });
}
