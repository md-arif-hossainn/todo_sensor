import 'package:flutter/material.dart';

class MainTaskField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const MainTaskField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter Task',
        border: InputBorder.none,
      ),
      onSubmitted: (value) => onSubmitted(value),
    );
  }
}
