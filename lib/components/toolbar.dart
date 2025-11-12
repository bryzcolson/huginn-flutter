import 'package:flutter/material.dart';
import 'toolbar/constants.dart';
import 'toolbar/theme.dart';
import 'toolbar/address_bar.dart';
import 'toolbar/toolbar_button.dart';

/// Main toolbar widget for browser navigation
class Toolbar extends StatelessWidget {
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
          enabled: canBack,
          onPressed: onBack,
          tooltip: ToolbarConstants.backTooltip,
        ),
        ToolbarButton(
          icon: ToolbarConstants.forwardIcon,
          enabled: canNext,
          onPressed: onNext,
          tooltip: ToolbarConstants.forwardTooltip,
        ),
        ToolbarButton(
          icon: ToolbarConstants.refreshIcon,
          enabled: canRefresh,
          onPressed: onRefresh,
          tooltip: ToolbarConstants.refreshTooltip,
        ),
        AddressBar(
          address: addr,
          onAddressChanged: onAddrChanged,
          onNavigate: onNavigate,
        ),
      ],
    ),
  );
}
