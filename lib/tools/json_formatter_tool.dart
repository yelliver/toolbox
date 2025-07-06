import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonFormatterTool extends StatefulWidget {
  @override
  State<JsonFormatterTool> createState() => _JsonFormatterToolState();
}

class _JsonFormatterToolState extends State<JsonFormatterTool> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  int _indentLevel = 2;

  void _formatJson() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    try {
      final dynamic parsed = jsonDecode(input);
      final formatted = JsonEncoder.withIndent(' ' * _indentLevel).convert(parsed);
      setState(() {
        _outputController.text = formatted;
      });
    } catch (e) {
      _showError('Invalid JSON format');
    }
  }

  void _minifyJson() {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    try {
      final dynamic parsed = jsonDecode(input);
      final minified = jsonEncode(parsed);
      setState(() {
        _outputController.text = minified;
      });
    } catch (e) {
      _showError('Invalid JSON format');
    }
  }

  void _copyToClipboard(String text) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _inputController,
          decoration: InputDecoration(
            labelText: 'Raw JSON',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _inputController.clear(),
              tooltip: 'Clear',
            ),
          ),
          maxLines: 6,
          minLines: 4,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _formatJson,
                icon: const Icon(Icons.auto_fix_high),
                label: const Text('Format'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _minifyJson,
                icon: const Icon(Icons.compress),
                label: const Text('Minify'),
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: _indentLevel,
              items: const [
                DropdownMenuItem(value: 2, child: Text('2 spaces')),
                DropdownMenuItem(value: 4, child: Text('4 spaces')),
                DropdownMenuItem(value: 8, child: Text('8 spaces')),
              ],
              onChanged: (value) {
                setState(() {
                  _indentLevel = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _outputController,
          decoration: InputDecoration(
            labelText: 'Formatted JSON',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () => _copyToClipboard(_outputController.text),
              tooltip: 'Copy',
            ),
          ),
          maxLines: 6,
          minLines: 4,
          readOnly: true,
        ),
      ],
    );
  }
}
