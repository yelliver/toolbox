import 'package:flutter/material.dart';
import 'package:toolbox/tools/simple_calculator_tool.dart';

import 'hash_calculator_tool.dart';
import 'jwt_decoder_tool.dart';

class ToolDefinition {
  final String name;
  final IconData icon;
  final Widget Function() builder;

  ToolDefinition({required this.name, required this.icon, required this.builder});
}

class ToolRegistry {
  static final Map<String, ToolDefinition> tools = {
    'hash_calculator': ToolDefinition(
      name: 'Hash Calculator',
      icon: Icons.lock,
      builder: () => const HashCalculatorTool(),
    ),
    'jwt_decoder': ToolDefinition(name: 'JWT Decoder', icon: Icons.vpn_key, builder: () => const JwtDecoderTool()),
    'simple_calculator': ToolDefinition(
      name: 'Simple Calculator',
      icon: Icons.calculate,
      builder: () => const SimpleCalculatorTool(),
    ),
  };
}
