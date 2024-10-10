import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String dbName) async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE mainTask (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE subTask (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        date TEXT,
        isChecked INTEGER,
        mainTaskId INTEGER,
        FOREIGN KEY (mainTaskId) REFERENCES mainTask (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> createMainTask(String name) async {
    final db = await database;
    return await db.insert('mainTask', {'name': name});
  }



  Future<List<Map<String, dynamic>>> getMainTasks() async {
    final db = await database;
    return await db.query('mainTask');
  }

  Future<void> deleteMainTask(int id) async {
    final db = await database;
    await db.delete('mainTask', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createSubTask(String name, String date, bool isChecked, int mainTaskId) async {
    final db = await database;
    print("============================================Successfully create subtask database");
    return await db.insert('subTask', {
      'name': name,
      'date': date,
      'isChecked': isChecked ? 1 : 0,
      'mainTaskId': mainTaskId,
    });

  }

  Future<int> getSubTaskCount(int mainTaskId) async {
    final db = await database; // your database instance
    final List<Map<String, dynamic>> subTasks = await db.query(
      'subTask',
      where: 'mainTaskId = ?',
      whereArgs: [mainTaskId],
    );
    return subTasks.length; // return the count of subtasks
  }


  Future<List<Map<String, dynamic>>> getSubTasks(int mainTaskId) async {
    final db = await database;
    return await db.query('subTask', where: 'mainTaskId = ?', whereArgs: [mainTaskId]);
  }

  Future<void> deleteSubTask(int id) async {
    final db = await database;
    await db.delete('subTask', where: 'id = ?', whereArgs: [id]);
  }
}
