import 'package:flutter/material.dart';
import 'base64_tool.dart';
import 'hash_calculator_tool.dart';
import 'jwt_decoder_tool.dart';
import 'simple_calculator_tool.dart';

class Tool {
  final String name;
  final IconData icon;
  final Widget Function() builder;

  Tool({required this.name, required this.icon, required this.builder});
}

class ToolRegistry {
  static final Map<String, Tool> tools = {
    'calculator': Tool(name: 'Calculator', icon: Icons.calculate, builder: () => SimpleCalculatorTool()),
    'hash': Tool(name: 'Hash Calculator', icon: Icons.tag, builder: () => HashCalculatorTool()),
    'jwt': Tool(name: 'JWT Decoder', icon: Icons.security, builder: () => JwtDecoderTool()),
    'base64': Tool(name: 'Base64 Encoder/Decoder', icon: Icons.transform, builder: () => Base64Tool()),
  };
}
