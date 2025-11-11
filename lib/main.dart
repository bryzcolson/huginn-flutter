import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'components/browser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure window (replaces Electron BrowserWindow)
  await windowManager.ensureInitialized();
  
  const windowOptions = WindowOptions(
    size: Size(800, 600),
    center: true,
    title: 'Huginn',
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Huginn',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Mono',
      ),
      home: const Browser(history: []),
    );
  }
}
