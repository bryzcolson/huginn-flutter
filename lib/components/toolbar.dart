import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Toolbar extends StatefulWidget {
  final String addr;
  final Function(String) onAddrChanged;
  final Function(String, bool) onNavigate;
  final bool canBack;
  final VoidCallback onBack;
  final bool canNext;
  final VoidCallback onNext;
  final bool canRefresh;
  final VoidCallback onRefresh;

  const Toolbar({
    super.key,
    required this.addr,
    required this.onAddrChanged,
    required this.onNavigate,
    required this.canBack,
    required this.onBack,
    required this.canNext,
    required this.onNext,
    required this.canRefresh,
    required this.onRefresh,
  });

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.addr;
  }

  @override
  void didUpdateWidget(Toolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the address changed externally (not from user input)
    // and the text field is not currently focused
    if (widget.addr != oldWidget.addr && !_focusNode.hasFocus) {
      _controller.text = widget.addr;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final url = _controller.text.trim();
    if (url.isNotEmpty) {
      _focusNode.unfocus();
      widget.onNavigate(url, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.arrow_back,
            enabled: widget.canBack,
            onPressed: widget.onBack,
            tooltip: 'Back',
          ),
          _ToolbarButton(
            icon: Icons.arrow_forward,
            enabled: widget.canNext,
            onPressed: widget.onNext,
            tooltip: 'Forward',
          ),
          _ToolbarButton(
            icon: Icons.refresh,
            enabled: widget.canRefresh,
            onPressed: widget.onRefresh,
            tooltip: 'Refresh',
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Enter Odin URL',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, height: 1.0),
                  onChanged: widget.onAddrChanged,
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final String tooltip;

  const _ToolbarButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    if (widget.enabled) {
      if (_isPressed) {
        backgroundColor = const Color(0xFFE0E0E0);
      } else if (_isHovered) {
        backgroundColor = const Color(0xFFF0F0F0);
      }
    }

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
            height: 30,
            width: 38,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: 22,
                color: widget.enabled ? Colors.black : Colors.black.withOpacity(0.15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
