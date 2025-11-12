import 'package:flutter/material.dart';
import 'theme.dart';

/// A toolbar button with hover and press state effects
class ToolbarButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final String tooltip;

  const ToolbarButton({
    super.key,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ToolbarTheme.getButtonBackgroundColor(
      enabled: widget.enabled,
      isHovered: _isHovered,
      isPressed: _isPressed,
    );

    final iconColor = ToolbarTheme.getButtonIconColor(widget.enabled);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.enabled ? widget.onPressed : null,
          child: Container(
            height: ToolbarTheme.buttonHeight,
            width: ToolbarTheme.buttonWidth,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(ToolbarTheme.buttonBorderRadius),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: ToolbarTheme.iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
