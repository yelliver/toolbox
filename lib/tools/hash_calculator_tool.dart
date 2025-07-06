import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class HashCalculatorTool extends StatefulWidget {
  const HashCalculatorTool({super.key});

  @override
  State<HashCalculatorTool> createState() => _HashCalculatorToolState();
}

class _HashCalculatorToolState extends State<HashCalculatorTool> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  void _calculateHash() {
    final input = _controller.text;
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    setState(() => _result = digest.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Enter text')),
        ElevatedButton(onPressed: _calculateHash, child: const Text('Calculate SHA256')),
        SelectableText(_result),
      ],
    );
  }
}
