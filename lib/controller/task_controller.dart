import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void addTask(Task task) {
    taskList.add(task);
    saveTasks();
  }

  void editTask(int index, Task task) {
    taskList[index] = task;
    saveTasks();
  }

  void deleteTask(int index) {
    taskList.removeAt(index);
    saveTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> decodedTasks = jsonDecode(tasksString);
      taskList.value = decodedTasks.map((taskJson) {
        return Task.fromJson(jsonDecode(taskJson));
      }).toList();
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedTasks =
        taskList.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setString('tasks', jsonEncode(encodedTasks));
  }
}
