import 'package:flutter/material.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.only(left: 16, right: 16, top: 28), // Padding around the container
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures content is spaced apart
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.grey), // Notification icon
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      'Remind Me', // Reminder Me text
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Space between rows
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Color.fromRGBO(54, 224, 224, 1.0),), // Calendar icon
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      'Due 12 Oct, 2024', // Date text
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(54, 224, 224, 1.0),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Space between rows
                Row(
                  children: [
                    Icon(Icons.note, color: Colors.grey), // Note icon
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(
                      'Add Note', // Note text
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Add delete section here at the bottom
            GestureDetector(
              onTap: () => _showCombinedDialog(context),
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.red), // Delete icon
                  SizedBox(width: 8), // Spacing between icon and text
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

  void _showCombinedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Delete Dialog
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                   // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Delete Permanently',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          // Add delete functionality here
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                // Cancel Dialog
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


