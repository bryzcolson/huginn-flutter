# Huginn - Flutter Desktop Application

A cross-platform Odin protocol browser built with Flutter, migrated from the original TypeScript/React/Electron implementation.

## Overview

Huginn is a desktop application that provides a browser interface for the Odin protocol. This Flutter version offers the same functionality as the original Electron app but with better performance, smaller bundle size, and true cross-platform support.

## Features

- Custom browser interface for Odin protocol
- Navigation controls (back, forward, refresh)
- URL address bar
- Content rendering with support for:
  - Headings (h1, h2, h3)
  - Paragraphs
  - Links/References
  - Code blocks
  - Lists (ordered and unordered)
  - Tables
  - Line breaks and separators

## Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Platform-specific requirements:
  - **macOS**: Xcode 14.0 or higher
  - **Windows**: Visual Studio 2022 with C++ desktop development
  - **Linux**: Standard development tools (gcc, make, etc.)

## Installation

1. **Install Flutter**
   
   Follow the official Flutter installation guide for your platform:
   https://docs.flutter.dev/get-started/install

2. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```

3. **Enable Desktop Support**
   ```bash
   # For macOS
   flutter config --enable-macos-desktop
   
   # For Windows
   flutter config --enable-windows-desktop
   
   # For Linux
   flutter config --enable-linux-desktop
   ```

4. **Navigate to Project Directory**
   ```bash
   cd flutter-migrate
   ```

5. **Get Dependencies**
   ```bash
   flutter pub get
   ```

## Running the Application

### Development Mode

Run the application in debug mode:

```bash
# macOS
flutter run -d macos

# Windows
flutter run -d windows

# Linux
flutter run -d linux
```

### Release Mode

For better performance, run in release mode:

```bash
# macOS
flutter run -d macos --release

# Windows
flutter run -d windows --release

# Linux
flutter run -d linux --release
```

## Building for Distribution

### macOS

```bash
flutter build macos --release
```

The built app will be located at:
`build/macos/Build/Products/Release/huginn.app`

### Windows

```bash
flutter build windows --release
```

The built app will be located at:
`build/windows/runner/Release/`

### Linux

```bash
flutter build linux --release
```

The built app will be located at:
`build/linux/x64/release/bundle/`

## Project Structure

```
flutter-migrate/
├── lib/
│   ├── main.dart                 # Application entry point
│   ├── views/
│   │   └── huginn_view.dart      # Main application view
│   ├── components/
│   │   ├── browser.dart          # Browser component with navigation
│   │   ├── toolbar.dart          # Toolbar with address bar and controls
│   │   └── renderer.dart         # Content renderer for Odin protocol
│   └── utils/
│       └── client.dart           # Network client for Odin protocol
├── pubspec.yaml                  # Project dependencies
└── README.md                     # This file
```

## Key Differences from Electron Version

### Advantages

1. **Smaller Bundle Size**: ~20-40MB vs 100-200MB for Electron
2. **Better Performance**: Native compilation, no Chromium overhead
3. **Lower Memory Usage**: Significantly reduced memory footprint
4. **True Cross-Platform**: Single codebase for desktop and mobile
5. **Native Look & Feel**: Better OS integration

### Technical Changes

- **State Management**: React hooks → Flutter StatefulWidget
- **Styling**: styled-components → Flutter widget composition
- **Navigation**: React Router → Flutter Navigator (if needed)
- **Network**: Node.js Net → Dart Socket
- **UI Framework**: React → Flutter widgets

## Odin Protocol

The application connects to Odin protocol servers on port 1866. The protocol uses tab-separated commands:

- `odin\tpreflight\t<path>` - Check if resource exists
- `odin\tpull\t<path>` - Retrieve resource content

Response codes:
- `A` - Success
- `B` - File not found
- `C` - Malformed request
- `D` - Server error

## Development

### Hot Reload

Flutter supports hot reload during development. After making changes to the code, press `r` in the terminal to hot reload, or `R` for a full restart.

### Debugging

Use Flutter DevTools for debugging:

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

Then run your app with:

```bash
flutter run -d <platform>
```

### Code Style

The project follows standard Dart/Flutter conventions:
- Use `flutter format` to format code
- Use `flutter analyze` to check for issues

## Troubleshooting

### Window Manager Issues

If you encounter issues with window management, ensure the `window_manager` package is properly configured for your platform. Check the package documentation at:
https://pub.dev/packages/window_manager

### Network Connection Issues

If the app cannot connect to Odin servers:
1. Verify the server is running on port 1866
2. Check firewall settings
3. Ensure the hostname is correct (defaults to localhost)

### Build Issues

If you encounter build issues:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Try building again

## License

ISC

## Author

bryzcolson (original Electron version)
Migrated to Flutter

## Contributing

Contributions are welcome! Please ensure your code follows Flutter best practices and includes appropriate documentation.
