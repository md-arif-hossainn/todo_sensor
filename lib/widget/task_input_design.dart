import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskInputDesign extends StatelessWidget {
  final bool isChecked;
  final Function(bool?) onCheckboxChanged;
  final TextEditingController controller;
  final Function(String) onTaskChanged;
  final Function(String) onTaskSubmitted;
  final Function onSubmit;
  final VoidCallback onDateTap;
  final DateTime? selectedDate;

  const TaskInputDesign({
    super.key,
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.controller,
    required this.onTaskChanged,
    required this.onTaskSubmitted,
    required this.onSubmit,
    required this.onDateTap,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Column(
      children: [
        Row(
          children: [
            // Checkbox with hardcoded styling
            Checkbox(
              value: isChecked,
              activeColor: const Color.fromRGBO(54, 224, 224, 1.0),
              checkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: onCheckboxChanged,
              side: const BorderSide(
                color: Colors.grey,
                width: 1.25,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            const SizedBox(width: 14),
            // Task TextField
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Add a Task",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: onTaskChanged,
                onSubmitted: onTaskSubmitted,
              ),
            ),
            // Check Icon Button with hardcoded color
            GestureDetector(
              onTap: () => onSubmit(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.text.isNotEmpty
                      ? const Color.fromRGBO(54, 224, 224, 1.0)
                      : Colors.grey,
                ),
                child: const Icon(
                  Icons.check,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            IconButton(
              onPressed: () {
                // Handle alarm icon click
              },
              icon: const Icon(Icons.notifications, color: Colors.grey),
            ),
            IconButton(
              onPressed: () {
                // Handle note icon click
              },
              icon: const Icon(Icons.note, color: Colors.grey),
            ),
            IconButton(
              onPressed: onDateTap,
              icon: Icon(
                Icons.calendar_month,
                color: selectedDate == null
                    ? Colors.grey
                    : const Color.fromRGBO(54, 224, 224, 1.0),
              ),
            ),
            selectedDate == null
                ? const Text('')
                : Text(
              DateFormat('EEE, dd MMM').format(selectedDate!),
              style: const TextStyle(
                color: Color.fromRGBO(54, 224, 224, 1.0),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

