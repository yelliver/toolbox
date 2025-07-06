import 'package:flutter/material.dart';
import 'tool_workspace.dart';

void main() {
  runApp(const ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Toolbox',
      theme: ThemeData.dark(),
      home: const ToolWorkspace(),
      debugShowCheckedModeBanner: false,
    );
  }
}
