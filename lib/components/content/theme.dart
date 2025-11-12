import 'package:flutter/material.dart';

/// Theme constants for the content renderer
class RendererTheme {
  // Text styles
  static const baseTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
  );

  static const heading1TextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static const heading2TextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static const heading3TextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static const linkTextStyle = TextStyle(
    fontSize: 12,
    color: linkColor,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.solid,
    decorationColor: linkColor,
  );

  static const codeTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.black,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal,
  );

  // Colors
  static const linkColor = Color(0xFF0366D6);
  static const codeBackgroundColor = Color(0xFFEAF1F6);
  static const hoverBackgroundColor = Color(0xFFEAF1F6);
  static const separatorColor = Colors.black;
  static const tableBorderColor = Colors.black;

  // Spacing
  static const containerPadding = EdgeInsets.all(24);
  static const headingVerticalPadding = EdgeInsets.symmetric(vertical: 8);
  static const paragraphVerticalPadding = EdgeInsets.symmetric(vertical: 4);
  static const codeBlockMargin = EdgeInsets.symmetric(vertical: 8);
  static const codeBlockPadding = EdgeInsets.all(12);
  static const listVerticalPadding = EdgeInsets.symmetric(vertical: 8);
  static const listItemPadding = EdgeInsets.only(left: 16, bottom: 4);
  static const tableVerticalPadding = EdgeInsets.symmetric(vertical: 8);
  static const tableCellPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const referencePadding = EdgeInsets.symmetric(vertical: 2);

  // Sizes
  static const double minContainerWidth = 664;
  static const double lineBreakHeight = 8;
  static const double referenceSpacing = 4;
  static const double codeBlockBorderRadius = 4;
  static const double tableBorderWidth = 1;

  // Misc
  static const listItemBullet = '• ';

  /// Get text style for a specific heading level
  static TextStyle getHeadingStyle(int level) {
    switch (level) {
      case 1:
        return heading1TextStyle;
      case 2:
        return heading2TextStyle;
      case 3:
        return heading3TextStyle;
      default:
        return baseTextStyle;
    }
  }
}
