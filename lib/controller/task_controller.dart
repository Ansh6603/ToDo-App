import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/database_helper.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void addTask(Task task) async {
    await dbHelper.insertTask(task);
    loadTasks();
  }

  void editTask(Task task) async {
    await dbHelper.updateTask(task);
    loadTasks();
  }

  void deleteTask(int id) async {
    await dbHelper.deleteTask(id);
    loadTasks();
  }

  void loadTasks() async {
    final List<Map<String, dynamic>> taskMapList = await dbHelper.getTaskMapList();
    taskList.value = taskMapList.map((taskMap) => Task.fromJson(taskMap)).toList();
  }
}
