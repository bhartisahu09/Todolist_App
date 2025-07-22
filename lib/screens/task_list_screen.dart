import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {

  const TaskListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.filteredTasks;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6D5BFF), Color.fromARGB(255, 179, 161, 254)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'ToDo List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          actions: [
            PopupMenuButton<TaskFilter>(
              tooltip: 'Filter Tasks',
              icon: const Icon(Icons.filter_list),
              onSelected: provider.setFilter,
              itemBuilder: (context) => const [
                PopupMenuItem(value: TaskFilter.all, child: Text('All')),
                PopupMenuItem(value: TaskFilter.completed, child: Text('Completed')),
                PopupMenuItem(value: TaskFilter.incomplete, child: Text('Incomplete')),
              ],
            ),
          ],
        ),
        body: tasks.isEmpty
            ? const Center(
                child: Text(
                  'No tasks found.',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                    color:Colors.white,
                      
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: GestureDetector(
                        onTap: () => provider.toggleTaskCompletion(task),
                        child: CircleAvatar(
                          backgroundColor: task.isCompleted ? Colors.green : Colors.grey.shade300,
                          child: Icon(
                            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                            color: task.isCompleted ? Colors.white : Colors.black45,
                          ),
                        ),
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color:  Colors.black87,
                        ),
                      ),
                      subtitle: task.dueDate != null
                          ? Text(
                              'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            tooltip: 'Edit Task',
                            onPressed: () async {
                              final result = await _openAddEditDialog(context, task);
                              if (result == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Task updated')),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            tooltip: 'Delete Task',
                            onPressed: () async {
                              await provider.deleteTask(task.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Task deleted')),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () => provider.toggleTaskCompletion(task),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'addTaskBtn',
          backgroundColor: const Color(0xFF6D5BFF),
          onPressed: () async {
            final result = await _openAddEditDialog(context);
            if (result == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added')),
              );
            }
          },
          label: const Text('Add Task'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<bool?> _openAddEditDialog(BuildContext context, [OfflineTaskModel? task]) async {
    return await showGeneralDialog<bool>(
      context: context,
      barrierLabel: "Task Dialog",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (_, animation, __, ___) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: AddEditTaskScreen(task: task),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
