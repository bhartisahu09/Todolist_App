import 'task_database.dart';
import '../../models/task_model.dart';

class TaskDBMethods {
  static final TaskDBMethods instance = TaskDBMethods._init();
  TaskDBMethods._init();

  /// Insert new task into local database
  Future<OfflineTaskModel> createTask(OfflineTaskModel model) async {
    final db = await DBHelper.instance.database;
    final id = await db.insert(OfflineTaskModel.tableName, model.toMap());
    model.id = id;
    return model;
  }

  /// Get all tasks from local database
  Future<List<OfflineTaskModel>> readAllTasks() async {
    final db = await DBHelper.instance.database;
    final result = await db.query(
      OfflineTaskModel.tableName,
      orderBy: '${OfflineTaskModel.columnId} DESC',
    );
    return result.map((map) => OfflineTaskModel.fromMap(map)).toList();
  }

  /// Update a task based on ID
  Future<int> updateTask(OfflineTaskModel task) async {
    final db = await DBHelper.instance.database;
    return await db.update(
      OfflineTaskModel.tableName,
      task.toMap(),
      where: '${OfflineTaskModel.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  /// Delete a task based on ID
  Future<int> deleteTask(int id) async {
    final db = await DBHelper.instance.database;
    return await db.delete(
      OfflineTaskModel.tableName,
      where: '${OfflineTaskModel.columnId} = ?',
      whereArgs: [id],
    );
  }

  /// Clear all tasks (if needed)
  Future<void> clearAllTasks() async {
    final db = await DBHelper.instance.database;
    await db.delete(OfflineTaskModel.tableName);
  }
}
