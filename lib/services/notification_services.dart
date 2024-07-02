import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      selectNotification(notificationResponse.payload);
    });
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    Get.to(() => Container(
          color: Colors.white,
        ));
  }

  Future<void> scheduleNotification(Task task) async {
    DateTime now = DateTime.now();
    if (task.date.year == now.year &&
        task.date.month == now.month &&
        task.date.day == now.day) {
      String notificationMessage = '${task.title}: ${task.description}\n'
          'End Date: ${DateFormat.yMd().format(task.date)}';

      tz.initializeTimeZones();
      await flutterLocalNotificationsPlugin.zonedSchedule(
        task.hashCode,
        'Task Reminder',
        notificationMessage,
        tz.TZDateTime.from(task.date, tz.local)
            .subtract(const Duration(minutes: 10)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_reminders_channel',
            'Task Reminders',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }
}
