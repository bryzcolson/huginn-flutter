import 'package:flutter/material.dart';
import 'constants.dart';
import 'theme.dart';

/// Address bar widget for entering URLs
class AddressBar extends StatefulWidget {
  final String address;
  final AddressChangedCallback onAddressChanged;
  final NavigationCallback onNavigate;

  const AddressBar({
    super.key,
    required this.address,
    required this.onAddressChanged,
    required this.onNavigate,
  });

  @override
  State<AddressBar> createState() => _AddressBarState();
}

class _AddressBarState extends State<AddressBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.address);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(AddressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the address changed externally (not from user input)
    // and the text field is not currently focused
    if (widget.address != oldWidget.address && !_focusNode.hasFocus) {
      _controller.text = widget.address;
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
  Widget build(BuildContext context) => Expanded(
        child: Container(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: ToolbarConstants.addressBarHint,
                border: InputBorder.none,
                contentPadding: ToolbarTheme.addressBarPadding,
                isDense: true,
              ),
              style: ToolbarTheme.addressBarTextStyle,
              onChanged: widget.onAddressChanged,
              onSubmitted: (_) => _handleSubmit(),
            ),
          ),
        ),
      );
}
