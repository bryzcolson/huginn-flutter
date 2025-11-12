import 'package:flutter/material.dart';
import 'toolbar/constants.dart';
import 'toolbar/theme.dart';
import 'toolbar/address_bar.dart';
import 'toolbar/toolbar_button.dart';

/// Main toolbar widget for browser navigation
class Toolbar extends StatefulWidget {
  final String addr;
  final AddressChangedCallback onAddrChanged;
  final NavigationCallback onNavigate;
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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.addr.trim().isNotEmpty;
  }

  @override
  void didUpdateWidget(Toolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.addr != oldWidget.addr) {
      setState(() {
        _hasText = widget.addr.trim().isNotEmpty;
      });
    }
  }

  void _handleAddressChanged(String address) {
    setState(() {
      _hasText = address.trim().isNotEmpty;
    });
    widget.onAddrChanged(address);
  }

  void _handleGo() {
    if (_hasText) {
      widget.onNavigate(widget.addr, true);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    height: ToolbarTheme.toolbarHeight,
    padding: ToolbarTheme.toolbarPadding,
    decoration: const BoxDecoration(
      color: ToolbarTheme.toolbarBackgroundColor,
      boxShadow: ToolbarTheme.toolbarShadow,
    ),
    child: Row(
      children: [
        ToolbarButton(
          icon: ToolbarConstants.backIcon,
          enabled: widget.canBack,
          onPressed: widget.onBack,
          tooltip: ToolbarConstants.backTooltip,
        ),
        ToolbarButton(
          icon: ToolbarConstants.forwardIcon,
          enabled: widget.canNext,
          onPressed: widget.onNext,
          tooltip: ToolbarConstants.forwardTooltip,
        ),
        ToolbarButton(
          icon: ToolbarConstants.refreshIcon,
          enabled: widget.canRefresh,
          onPressed: widget.onRefresh,
          tooltip: ToolbarConstants.refreshTooltip,
        ),
        AddressBar(
          address: widget.addr,
          onAddressChanged: _handleAddressChanged,
          onNavigate: widget.onNavigate,
        ),
        ToolbarButton(
          icon: ToolbarConstants.goIcon,
          enabled: _hasText,
          onPressed: _handleGo,
          tooltip: ToolbarConstants.goTooltip,
        ),
      ],
    ),
  );
}
