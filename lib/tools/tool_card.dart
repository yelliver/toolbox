import 'package:flutter/material.dart';

class ToolCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final VoidCallback onClose;

  const ToolCard({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Container(
            color: Colors.grey[800],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: content,
          ),
        ],
      ),
    );
  }
}
