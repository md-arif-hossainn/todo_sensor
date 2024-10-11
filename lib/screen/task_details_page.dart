import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/sql_helper.dart';


class TaskDetailsPage extends StatefulWidget {
  final int? subTaskId;
  final String? subTaskName;
  final String? date;
  const TaskDetailsPage({super.key,this.subTaskId,this.subTaskName,this.date});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "No Date Selected";
    }
    try {
      DateTime parsedDate = DateTime.parse(dateString.split(' ')[0]);
      return DateFormat('EEE, d MMMM').format(parsedDate);
    } catch (e) {
      return "Invalid date";
    }
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subTaskName!),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.grey), // Notification icon
                    SizedBox(width: 8),
                    Text(
                      'Remind Me',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Space between rows
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: widget.date == "" ? Colors.grey : const Color.fromRGBO(54, 224, 224, 1.0),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(widget.date),
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.date == "" ? Colors.grey : const Color.fromRGBO(54, 224, 224, 1.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.note, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Add Note',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => _showAlertDialog(context),
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Delete', // Delete text
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.15,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Text(
                    '${widget.subTaskName} will be permanently delete?',
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      _databaseHelper.deleteSubTask(widget.subTaskId!);
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      'Delete Task',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(54, 224, 224, 1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}