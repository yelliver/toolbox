import 'package:flutter/material.dart';

import 'tool_workspace.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      home: ToolWorkspace(isDarkMode: _isDarkMode, onThemeToggle: _toggleTheme),
    );
  }
}
