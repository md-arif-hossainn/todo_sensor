import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class SubTaskCard extends StatefulWidget {
  final String title;
  final String? date;// Pass a date
  final bool? isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;

  const SubTaskCard({
    super.key,
    required this.title,
    this.date,
    this.isChecked,
    this.onCheckboxChanged,
  });

  @override
  SubTaskCardState createState() => SubTaskCardState();
}

class SubTaskCardState extends State<SubTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.isChecked,
                  activeColor: const Color.fromRGBO(54, 224, 224, 1.0), // Active color
                  checkColor: Colors.white, // Color of the check icon
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4), // Slightly rounded corners
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // To adjust tap area
                  onChanged: widget.onCheckboxChanged,
                  side: const BorderSide(
                    color: Colors.grey, // Border color
                    width: 1.25, // Border width
                  ),
                  visualDensity: VisualDensity.adaptivePlatformDensity, // To adjust size
                ),
                Expanded(
                  child: Text(
                    widget.title, // Use the passed title
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.star_border, // Change this to any icon you prefer
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: widget.date == null ? Colors.grey : const Color.fromRGBO(54, 224, 224, 1.0),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.date == ''
                        ? 'No selected date'
                        : DateFormat('EEE, dd MMM').format(DateTime.parse(widget.date!)),
                    style: const TextStyle(
                      color: Color.fromRGBO(54, 224, 224, 1.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
