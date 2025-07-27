import 'package:flutter/material.dart';

class BinaryDropdown extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const BinaryDropdown({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Yes (1)')),
          DropdownMenuItem(value: 0, child: Text('No (0)')),
        ],
        onChanged: (v) => onChanged(v ?? 0),
        dropdownColor: Colors.black,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
