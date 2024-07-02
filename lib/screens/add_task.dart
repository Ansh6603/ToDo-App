import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:todo_app/widgets/text_field.dart';
import '../controller/task_controller.dart';
import '../models/task_model.dart';

class AddTask extends StatefulWidget {
  final Task? task;
  final int? index;

  const AddTask({super.key, this.task, this.index});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _selectedPriority = 1;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _selectedPriority = widget.task!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  title: "Title",
                  hint: "Enter your title",
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                InputField(
                  title: "Description",
                  hint: "Enter your description",
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined,
                        color: Colors.grey),
                    onPressed: _getDateFromUser,
                  ),
                  validator: (_) {
                    if (_selectedDate == null) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text("Priority",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                DropdownButton<int>(
                  value: _selectedPriority,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text("Low")),
                    DropdownMenuItem(value: 2, child: Text("Medium")),
                    DropdownMenuItem(value: 3, child: Text("High")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Task newTask = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        date: _selectedDate,
                        priority: _selectedPriority,
                      );
                      if (widget.task != null && widget.index != null) {
                        taskController.editTask(widget.index!, newTask);
                      } else {
                        taskController.addTask(newTask);
                      }
                      Get.back();
                    }
                  },
                  child: const Text("Save Task"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }
}
