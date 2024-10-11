
import 'package:flutter/material.dart';
import '../db/sql_helper.dart';
import 'add_task_page.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  TodoHomePageState createState() => TodoHomePageState();
}

class TodoHomePageState extends State<TodoHomePage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _mainTasks = [];

  @override
  void initState() {
    super.initState();
    _refreshMainTasks();
  }


  Future<void> _refreshMainTasks() async {
    final data = await _databaseHelper.getMainTasks();
    List<Map<String, dynamic>> tasksWithCounts = [];

    for (var mainTask in data) {
      final subTaskCount = await _databaseHelper.getSubTaskCount(mainTask['id']);
      // Combine main task data with its subtask count
      tasksWithCounts.add({
        ...mainTask,
        'subTaskCount': subTaskCount,
      });
    }

    setState(() {
      _mainTasks = tasksWithCounts;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          Flexible(
            child: _mainTasks.isNotEmpty
                ? _buildTaskList() // Display list of tasks if available
                : const Center(
              child: Text(
                'No tasks added yet',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: _mainTasks.length,
      itemBuilder: (context, index) {
        final mainTask = _mainTasks[index];
        return _buildTaskSummaryCard(
          mainTaskName: mainTask['name'] ?? 'No name',
          taskCount:  mainTask['subTaskCount'].toString(),
          index :  mainTask['id']
        );
      },
    );
  }


  Widget _buildTaskSummaryCard({
    required String mainTaskName,
    required String taskCount,
    required int index
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskPage(mainTaskId: index,mainTaskName: mainTaskName,)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.199),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.list, size: 28.0, color: Color(0xFF36E0E0)), // List icon
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(
                  mainTaskName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                taskCount,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF36E0E0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 35),
      child: SizedBox(
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: _buildProfileAndTaskCount(),
            ),
            _buildSearchIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAndTaskCount() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/05/52/15/68/360_F_552156839_hQTIBjd35zljkgSz65pDaUUSyKK53DtZ.jpg'), // Replace with your image URL
        ),
        SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nany Morgan', // Replace with the name
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  'Incomplete: 0', // Task count
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Text(
                  'Complete: 0',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchIcon() {
    return IconButton(
      icon: const Icon(Icons.search, size: 30),
      onPressed: () {
        print('Search icon pressed');
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        // Navigate to AddTaskPage and wait for a result
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTaskPage()),
        );

        if (result == true) {
          _refreshMainTasks();
        }
      },
      backgroundColor: const Color(0xFF36E0E0),
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

