/// Simple logger for OdinClient
class Logger {
  final String name;
  final bool enabled;

  Logger(this.name, {this.enabled = true});

  void fine(String message) {
    if (enabled) _log('FINE', message);
  }

  void info(String message) {
    if (enabled) _log('INFO', message);
  }

  void warning(String message) {
    if (enabled) _log('WARNING', message);
  }

  void severe(String message) {
    if (enabled) _log('SEVERE', message);
  }

  void _log(String level, String message) {
    // ignore: avoid_print
    print('[$level] $name: $message');
  }
}
