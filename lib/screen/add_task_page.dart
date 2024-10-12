import 'package:flutter/material.dart';
import 'package:todo_sensor/screen/task_details_page.dart';
import 'package:todo_sensor/widget/add_task_card.dart';
import 'package:todo_sensor/widget/main_task_field.dart';
import 'package:todo_sensor/widget/task_input_design.dart';
import 'package:todo_sensor/widget/sub_task_card.dart';
import 'package:intl/intl.dart';

import '../db/sql_helper.dart';
import '../services/notification_services.dart';

class AddTaskPage extends StatefulWidget {
  final int? mainTaskId;
  final String? mainTaskName;

  const AddTaskPage({super.key,  this.mainTaskId,this.mainTaskName});

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController mainTaskController = TextEditingController();
  final TextEditingController subTaskController = TextEditingController();
  bool _isTaskSubmitted = false;
  String _submittedTask = '';
  bool _isChecked = false;
  bool _isTaskInputVisible = false;
  DateTime? _selectedDate;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _mainTasks = [];
  List<Map<String, dynamic>> _subTasks = [];
  int newDatabaseID = 0;

  @override
  void dispose() {
    mainTaskController.dispose();
    subTaskController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.mainTaskId != null) {
      _isTaskSubmitted = true;
      _refreshMainTasks();
      if (widget.mainTaskName != null) {
        _submittedTask = widget.mainTaskName!;
      }
    }
    NotificationServices.askForNotificationPermission();
    super.initState();
  }


  Future<void> _refreshMainTasks() async {
    List<Map<String, dynamic>> subTaskData;
    final mainTaskData = await _databaseHelper.getMainTasks();
    if (widget.mainTaskId!=null) {
       subTaskData = await _databaseHelper.getSubTasks(widget.mainTaskId!);
    }  else{
       subTaskData = await _databaseHelper.getSubTasks(newDatabaseID);
    }
    setState(() {
      _mainTasks = mainTaskData;
      _subTasks = subTaskData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 22.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(54, 224, 224, 1.0), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, // Reduced horizontal padding for a thinner look
                  vertical: 4, // Reduced vertical padding for a thinner button
                ),
                minimumSize: const Size(40, 24), // Set the minimum size of the button
              ),
              onPressed: () {
                _passDataBack(); // Navigate back to previous screen
              },
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontSize: 16, // Text size
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _isTaskSubmitted ? _displaySubmittedTask() : MainTaskField(
              controller: mainTaskController,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  newDatabaseID = await _databaseHelper.createMainTask(mainTaskController.text);
                  setState(() {
                    _submittedTask = value;
                    _isTaskSubmitted = true;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildTaskList(),
            ),
            _isTaskSubmitted
                ? _isTaskInputVisible
                ? Container()
                : AddTaskCard(
                onTap: (){
                  setState(() {
                    _isTaskInputVisible = true;
                  });
                }
                )
                : Container(),
            _isTaskInputVisible ? TaskInputDesign(
              isChecked: _isChecked,
              onCheckboxChanged: _handleCheckboxChanged,
              controller: subTaskController,
              onTaskChanged: (value) {
                setState(() {});
              },
              onTaskSubmitted: (value) async {
                _handleTaskSubmit();
               if(_selectedDate == ''){

               }else{
                 await NotificationServices.scheduleNotificationAtSpecificTime(
                   title: "Task Reminder",
                   body: "Are you complete this ${subTaskController.text} task?",
                   payload: "Scheduled Notification",
                  date:_selectedDate.toString()
                 );
               }
              },
              onSubmit: _handleTaskSubmit,
              onDateTap: _showDatePicker,
              selectedDate: _selectedDate,
            ) : Container()
          ],
        ),
      ),
    );
  }


  Widget _displaySubmittedTask() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$_submittedTask (${_subTasks.length})',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void _handleCheckboxChanged(bool? value) {
    setState(() {
      _isChecked = value!;
    });
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _subTasks.length,
      itemBuilder: (context, index) {
        final subTask = _subTasks[index];
        print('=======================$subTask=======================');
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskDetailsPage(subTaskId: subTask['id'],subTaskName: subTask['name'],date: subTask['date'])),
            );
            if (result == true) {
              _refreshMainTasks();
            }
          },
          child: SubTaskCard(
            title: subTask['name'] ?? 'No name',
            date: subTask['date'] ?? '',
            isChecked: (subTask['isChecked'] ?? 0) == 1,
            onCheckboxChanged: (bool? value) {
              setState(() {
              });
            },
          
          ),
        );
      },
    );
  }


  Future<void> _handleTaskSubmit() async {
    if (subTaskController.text.isNotEmpty) {

      print("sent database request with previous id");
      if (widget.mainTaskId != null) {
        await _databaseHelper.createSubTask(
          subTaskController.text.isNotEmpty ? subTaskController.text : '',
          _selectedDate != null ? _selectedDate.toString() : '', // Example date
          _isChecked ? true : false,
          widget.mainTaskId!,
        );
      }  else{
        print("sent database request with new id");
        await _databaseHelper.createSubTask(
          subTaskController.text.isNotEmpty ? subTaskController.text : '',
          _selectedDate != null ? _selectedDate.toString() : '', // Example date
          _isChecked ? true : false,
          newDatabaseID,
        );
      }


      setState(() {
        subTaskController.clear();
        _isTaskInputVisible = false;
        _selectedDate = null;
        _isChecked = false;
        _refreshMainTasks();
      });

      FocusScope.of(context).unfocus();
    }
  }


  void _passDataBack() {
    Navigator.pop(context, true);
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(54, 224, 224, 1.0),
            hintColor: const Color.fromRGBO(54, 224, 224, 1.0),
            colorScheme: const ColorScheme.light(primary: Color.fromRGBO(54, 224, 224, 1.0)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
