import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class SimpleCalculatorTool extends StatefulWidget {
  const SimpleCalculatorTool({super.key});

  @override
  State<SimpleCalculatorTool> createState() => _SimpleCalculatorToolState();
}

class _SimpleCalculatorToolState extends State<SimpleCalculatorTool> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  final List<String> _history = [];

  void _calculate() {
    final expression = _controller.text.trim();
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toString();
        _history.insert(0, '$expression = $_result');
      });
    } catch (e) {
      setState(() {
        _result = 'Error: Invalid Expression';
        _history.insert(0, '\$expression = Error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Enter expression (e.g., 2+3*4)'),
          onSubmitted: (_) => _calculate(),
        ),
        Row(
          children: [
            ElevatedButton(onPressed: _calculate, child: const Text('Calc')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => setState(() => _history.clear()), child: const Text('Clear History')),
          ],
        ),
        const SizedBox(height: 8),
        SelectableText(_result),
        if (_history.isNotEmpty) ...[
          const Divider(),
          const Text('History:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            height: 150,
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    final expression = item.split('=')[0].trim();
                    setState(() {
                      _controller.text = expression;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
