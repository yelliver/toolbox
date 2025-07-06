import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'tools/tool_card.dart';
import 'tools/tool_registry.dart';

class ToolInstance {
  final String id;
  final String toolKey;

  ToolInstance({required this.id, required this.toolKey});
}

class ToolWorkspace extends StatefulWidget {
  const ToolWorkspace({super.key});

  @override
  State<ToolWorkspace> createState() => _ToolWorkspaceState();
}

class _ToolWorkspaceState extends State<ToolWorkspace> {
  final List<ToolInstance> _activeTools = [];
  final uuid = const Uuid();

  int _calculateNumColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / 700).floor().clamp(1, 4); // max 4 columns if needed
  }

  void _addTool(String toolKey) {
    setState(() {
      _activeTools.add(ToolInstance(id: uuid.v4(), toolKey: toolKey));
    });
  }

  void _removeTool(String id) {
    setState(() {
      _activeTools.removeWhere((tool) => tool.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int numColumns = _calculateNumColumns(context);
    List<List<Widget>> columns = List.generate(numColumns, (_) => []);

    for (int i = 0; i < _activeTools.length; i++) {
      final instance = _activeTools[i];
      final tool = ToolRegistry.tools[instance.toolKey];
      if (tool != null) {
        columns[i % numColumns].add(
          ToolCard(
            key: ValueKey(instance.id),
            title: tool.name,
            icon: tool.icon,
            content: tool.builder(),
            onClose: () => _removeTool(instance.id),
          ),
        );
      }
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 220,
            color: Colors.grey[900],
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text('Tool Library', style: TextStyle(fontSize: 18)),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: ToolRegistry.tools.entries.map((entry) {
                      return ListTile(
                        leading: Icon(entry.value.icon),
                        title: Text(entry.value.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addTool(entry.key),
                          tooltip: 'Add ${entry.value.name}',
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(numColumns, (index) {
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: columns[index]
                        .map((card) => Padding(padding: const EdgeInsets.only(bottom: 8), child: card))
                        .toList(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
