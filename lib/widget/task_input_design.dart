// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class TaskInput extends StatefulWidget {
//   final TextEditingController controller;
//   final DateTime? selectedDate;
//   final bool isChecked;
//   final Function(bool) onCheckedChanged;
//   final Function onSubmit;
//   final Function onDatePickerTap;
//
//   TaskInput({
//     required this.controller,
//     this.selectedDate,
//     required this.isChecked,
//     required this.onCheckedChanged,
//     required this.onSubmit,
//     required this.onDatePickerTap,
//   });
//
//   @override
//   _TaskInputState createState() => _TaskInputState();
// }
//
// class _TaskInputState extends State<TaskInput> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Checkbox(
//               value: widget.isChecked,
//               onChanged: (bool? value) {
//                 if (value != null) {
//                   widget.onCheckedChanged(value);
//                 }
//               },
//             ),
//             Expanded(
//               child: TextField(
//                 controller: widget.controller,
//                 decoration: const InputDecoration(
//                   hintText: 'Add a Task',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (value) => widget.onSubmit(),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: () => widget.onSubmit(),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.calendar_today),
//               onPressed: () => widget.onDatePickerTap(),
//             ),
//             widget.selectedDate != null
//                 ? Text(DateFormat('EEE, dd MMM').format(widget.selectedDate!))
//                 : const Text('No date selected'),
//           ],
//         ),
//       ],
//     );
//   }
// }

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
    Key? key,
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.controller,
    required this.onTaskChanged,
    required this.onTaskSubmitted,
    required this.onSubmit,
    required this.onDateTap,
    this.selectedDate,
  }) : super(key: key);

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

