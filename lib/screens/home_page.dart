import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:todo_app/services/notification_services.dart';
import '../controller/task_controller.dart';
import 'add_task.dart';
import '../models/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotifyHelper notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotification();
    _scheduleTodayNotifications();
  }

  final TaskController taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  String _searchText = "";

  void _scheduleTodayNotifications() {
    DateTime now = DateTime.now();
    List<Task> todayTasks = taskController.taskList.where((task) =>
      task.date.year == now.year &&
      task.date.month == now.month &&
      task.date.day == now.day
    ).toList();

    for (var task in todayTasks) {
      notifyHelper.scheduleNotification(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDoList App"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(_selectedDate),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const Text(
                      "Today",
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () => Get.to(const AddTask()),
                  child: Container(
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        " + Add Task",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              child: DatePicker(
                DateTime.now(),
                height: 100,
                width: 80,
                initialSelectedDate: _selectedDate,
                selectionColor: const Color.fromARGB(255, 32, 97, 209),
                selectedTextColor: Colors.white,
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Search tasks...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                List<Task> filteredTasks = taskController.taskList
                    .where((task) =>
                        task.date.year == _selectedDate.year &&
                        task.date.month == _selectedDate.month &&
                        task.date.day == _selectedDate.day &&
                        (task.title.contains(_searchText) ||
                            task.description.contains(_searchText)))
                    .toList();

                filteredTasks.sort((a, b) => b.priority.compareTo(a.priority));

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    Task task = filteredTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Get.to(AddTask(task: task, index: index));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              taskController.deleteTask(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        task.isCompleted = !task.isCompleted;
                        taskController.saveTasks();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
