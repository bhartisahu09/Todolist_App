import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class AddEditTaskScreen extends StatelessWidget {
  final OfflineTaskModel? task;
  const AddEditTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _AddEditTaskForm(task: task),
      ),
    );
  }
}

class _AddEditTaskForm extends StatefulWidget {
  final OfflineTaskModel? task;
  const _AddEditTaskForm({Key? key, this.task}) : super(key: key);

  @override
  State<_AddEditTaskForm> createState() => _AddEditTaskFormState();
}

class _AddEditTaskFormState extends State<_AddEditTaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Task' : 'Add Task',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close,
                      color: Color.fromARGB(255, 89, 39, 176)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a title'
                  : null,
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _description,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _description = value ?? '',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'No due date selected'
                        : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        _dueDate = picked;
                      });
                    }
                  },
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      color: Color(0xFF6D5BFF),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final provider =
                        Provider.of<TaskProvider>(context, listen: false);
                    if (isEditing) {
                      final updatedTask = OfflineTaskModel(
                        id: widget.task!.id,
                        title: _title,
                        description: _description,
                        dueDate: _dueDate,
                        isCompleted: widget.task!.isCompleted,
                      );
                      await provider.updateTask(updatedTask);
                    } else {
                      final newTask = OfflineTaskModel(
                        title: _title,
                        description: _description,
                        dueDate: _dueDate,
                      );
                      await provider.addTask(newTask);
                    }
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D5BFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isEditing ? 'Update Task' : 'Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
