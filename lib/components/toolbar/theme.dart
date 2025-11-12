import 'package:flutter/material.dart';

/// Theme constants for the toolbar component
class ToolbarTheme {
  // Toolbar dimensions
  static const double toolbarHeight = 38;
  static const double buttonHeight = 30;
  static const double buttonWidth = 38;
  static const double iconSize = 22;

  // Toolbar padding and spacing
  static const toolbarPadding = EdgeInsets.all(4);
  static const addressBarPadding = EdgeInsets.symmetric(horizontal: 12);

  // Colors
  static const toolbarBackgroundColor = Colors.white;
  static const buttonHoverColor = Color(0xFFF0F0F0);
  static const buttonPressedColor = Color(0xFFE0E0E0);
  static const buttonIconColor = Colors.black;
  static const double buttonDisabledOpacity = 0.15;

  // Border radius
  static const double buttonBorderRadius = 5;

  // Shadow
  static const toolbarShadow = [
    BoxShadow(
      color: Color(0x1A000000), // Colors.black.withOpacity(0.1)
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Text styles
  static const addressBarTextStyle = TextStyle(
    fontSize: 14,
    height: 1.0,
  );

  /// Get button background color based on state
  static Color getButtonBackgroundColor({
    required bool enabled,
    required bool isHovered,
    required bool isPressed,
  }) {
    if (!enabled) return Colors.transparent;
    if (isPressed) return buttonPressedColor;
    if (isHovered) return buttonHoverColor;
    return Colors.transparent;
  }

  /// Get button icon color based on enabled state
  static Color getButtonIconColor(bool enabled) => enabled
      ? buttonIconColor
      : buttonIconColor.withValues(alpha: buttonDisabledOpacity);
}
