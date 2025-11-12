import 'package:flutter/material.dart';

/// Callback type for address changes
typedef AddressChangedCallback = void Function(String address);

/// Callback type for navigation
typedef NavigationCallback = void Function(String url, bool addToHistory);

/// Constants for toolbar text and tooltips
class ToolbarConstants {
  // Tooltip messages
  static const String backTooltip = 'Back';
  static const String forwardTooltip = 'Forward';
  static const String refreshTooltip = 'Refresh';
  static const String goTooltip = 'Go';

  // Placeholder text
  static const String addressBarHint = 'Enter Odin URL';

  // Icons
  static const IconData backIcon = Icons.arrow_back;
  static const IconData forwardIcon = Icons.arrow_forward;
  static const IconData refreshIcon = Icons.refresh;
  static const IconData goIcon = Icons.flight_takeoff;
}
