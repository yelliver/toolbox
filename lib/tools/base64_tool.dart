import 'dart:convert';
        import 'package:flutter/material.dart';
        import 'package:flutter/services.dart';

        class Base64Tool extends StatefulWidget {
          @override
          State<Base64Tool> createState() => _Base64ToolState();
        }

        class _Base64ToolState extends State<Base64Tool> {
          final TextEditingController _plainTextController = TextEditingController();
          final TextEditingController _base64Controller = TextEditingController();

          void _encodeText() {
            final plainText = _plainTextController.text.trim();
            if (plainText.isEmpty) return;

            try {
              final encoded = base64Encode(utf8.encode(plainText));
              setState(() {
                _base64Controller.text = encoded;
              });
            } catch (e) {
              _showError('Error encoding text');
            }
          }

          void _decodeText() {
            final base64Text = _base64Controller.text.trim();
            if (base64Text.isEmpty) return;

            try {
              final decoded = utf8.decode(base64Decode(base64Text));
              setState(() {
                _plainTextController.text = decoded;
              });
            } catch (e) {
              _showError('Invalid Base64 format');
            }
          }

          void _copyToClipboard(String text) {
            if (text.isNotEmpty) {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            }
          }

          void _showError(String message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          }

          @override
          void dispose() {
            _plainTextController.dispose();
            _base64Controller.dispose();
            super.dispose();
          }

          @override
          Widget build(BuildContext context) {
            return Column(
              children: [
                TextField(
                  controller: _plainTextController,
                  decoration: InputDecoration(
                    labelText: 'Plain Text',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(_plainTextController.text),
                      tooltip: 'Copy',
                    ),
                  ),
                  maxLines: 4,
                  minLines: 3,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _encodeText,
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Encode to Base64'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _decodeText,
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('Decode from Base64'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _base64Controller,
                  decoration: InputDecoration(
                    labelText: 'Base64 Encoded',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () => _copyToClipboard(_base64Controller.text),
                      tooltip: 'Copy',
                    ),
                  ),
                  maxLines: 4,
                  minLines: 3,
                ),
              ],
            );
          }
        }
