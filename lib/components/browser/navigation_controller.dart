/// Manages browser navigation history and state
class NavigationController {
  final List<String> _history;
  int _position = -1;

  NavigationController(List<String> initialHistory)
    : _history = List.from(initialHistory);

  /// Current position in history
  int get position => _position;

  /// Navigation history
  List<String> get history => List.unmodifiable(_history);

  /// Current URL (if any)
  String? get currentUrl => _position >= 0 ? _history[_position] : null;

  /// Can navigate backwards
  bool get canGoBack => _position > 0;

  /// Can navigate forwards
  bool get canGoForward => _position < _history.length - 1;

  /// Can refresh (has current page)
  bool get canRefresh => _position >= 0;

  /// Add a URL to history and navigate to it
  void navigateTo(String url) {
    // Remove all forward history
    _history.removeRange(_position + 1, _history.length);

    // Add new URL
    _history.add(url);
    _position++;
  }

  /// Navigate backwards in history
  /// Returns the URL to navigate to, or null if can't go back
  String? goBack() {
    if (!canGoBack) return null;
    _position--;
    return _history[_position];
  }

  /// Navigate forwards in history
  /// Returns the URL to navigate to, or null if can't go forward
  String? goForward() {
    if (!canGoForward) return null;
    _position++;
    return _history[_position];
  }

  /// Get URL for refresh (current page)
  /// Returns the URL to reload, or null if no current page
  String? getRefreshUrl() {
    if (!canRefresh) return null;
    return _history[_position];
  }
}
