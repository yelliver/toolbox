import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JwtDecoderTool extends StatefulWidget {
  const JwtDecoderTool({super.key});

  @override
  State<JwtDecoderTool> createState() => _JwtDecoderToolState();
}

class _JwtDecoderToolState extends State<JwtDecoderTool> {
  final TextEditingController _controller = TextEditingController();
  String _headerDecoded = '';
  String _payloadDecoded = '';
  String? _expirationInfo;

  void _decodeJwt() {
    final token = _controller.text.trim();
    final parts = token.split('.');
    if (parts.length != 3) {
      setState(() {
        _headerDecoded = 'Invalid JWT structure';
        _payloadDecoded = '';
        _expirationInfo = null;
      });
      return;
    }

    try {
      final header = utf8.decode(base64Url.decode(_normalizeBase64(parts[0])));
      final payload = utf8.decode(base64Url.decode(_normalizeBase64(parts[1])));
      String? expirationInfo;
      final payloadMap = json.decode(payload) as Map<String, dynamic>;
      if (payloadMap.containsKey('exp')) {
        final expValue = payloadMap['exp'];
        if (expValue is int) {
          final expiration = DateTime.fromMillisecondsSinceEpoch(expValue * 1000);
          final now = DateTime.now();
          final isExpired = now.isAfter(expiration);
          expirationInfo = 'Expiration: \$expiration (\${isExpired ? "expired" : "valid"})';
        } else {
          expirationInfo = 'Invalid exp value in payload';
        }
      } else {
        expirationInfo = 'No exp claim found in payload';
      }
      setState(() {
        _headerDecoded = _formatJson(header);
        _payloadDecoded = _formatJson(payload);
        _expirationInfo = expirationInfo;
      });
    } catch (e) {
      setState(() {
        _headerDecoded = 'Error decoding JWT: \$e';
        _payloadDecoded = '';
        _expirationInfo = null;
      });
    }
  }

  String _normalizeBase64(String input) {
    return input.padRight(input.length + (4 - input.length % 4) % 4, '=');
  }

  String _formatJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(decoded);
    } catch (e) {
      return jsonString;
    }
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('JWT Decoder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Paste JWT here'),
              maxLines: 3,
            ),
            ElevatedButton(onPressed: _decodeJwt, child: const Text('Decode JWT')),
            const SizedBox(height: 8),
            const Text('Header:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_headerDecoded),
            ElevatedButton(onPressed: () => _copy(_headerDecoded), child: const Text('Copy Header')),
            const SizedBox(height: 8),
            const Text('Payload:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_payloadDecoded),
            ElevatedButton(onPressed: () => _copy(_payloadDecoded), child: const Text('Copy Payload')),
            if (_expirationInfo != null) ...[
              const SizedBox(height: 8),
              Text(_expirationInfo!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ]
          ],
        ),
      ),
    );
  }
}
