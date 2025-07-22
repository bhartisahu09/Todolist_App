import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/database/task_db_methods.dart';

class TaskProvider extends ChangeNotifier {
  List<OfflineTaskModel> _tasks = [];
  List<OfflineTaskModel> get tasks => _tasks;

  TaskFilter _filter = TaskFilter.all;
  TaskFilter get filter => _filter;

  /// Load all tasks from local DB
  Future<void> loadTasks() async {
    _tasks = await TaskDBMethods.instance.readAllTasks();
    notifyListeners();
  }

  /// Set task filter (all / completed / incomplete)
  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  /// Add a new task to local DB
  Future<void> addTask(OfflineTaskModel task) async {
    await TaskDBMethods.instance.createTask(task);
    await loadTasks();
  }

  /// Update existing task in local DB
  Future<void> updateTask(OfflineTaskModel task) async {
    await TaskDBMethods.instance.updateTask(task);
    await loadTasks();
  }

  /// Delete task by ID
  Future<void> deleteTask(int id) async {
    await TaskDBMethods.instance.deleteTask(id);
    await loadTasks();
  }

  /// Toggle completion status
  Future<void> toggleTaskCompletion(OfflineTaskModel task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  /// Get tasks based on active filter
  List<OfflineTaskModel> get filteredTasks {
    switch (_filter) {
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.incomplete:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return _tasks;
    }
  }
}

enum TaskFilter { all, completed, incomplete }
