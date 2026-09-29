import 'package:flutter/material.dart';
//tow
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//tow
class Task {
  String name;
  bool isDone;

  Task({required this.name, this.isDone = false});
  //one
  //تحول المعلومات الى جيسون
  Map<String, dynamic> toJson() {
    return {'name': name, 'isDone': isDone};
  }
  //تعيد المعلومات
  Task.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      isDone = json['isDone'];
  //
  
  
}

class TaskData extends ChangeNotifier {
  final List<Task> tasks = [
    Task(name: 'شراء الخبز'),
    Task(name: 'دراسة Flutter'),
  ];
  void toggleTask(int index) {
    tasks[index].isDone = !tasks[index].isDone;
    saveTasks();
    notifyListeners();
  }

  void addNewTask(String task) {
    tasks.add(Task(name: task));
    saveTasks();
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.remove(tasks[index]);
    saveTasks();
    notifyListeners();
  }

  void editTask(int index, String task) {
    tasks[index] = Task(name: task);
    saveTasks();
    notifyListeners();
  }//three
  //دالة للحفظ
  Future<void> saveTasks() async {
  final tasksJson = tasks.map((task) {
    return jsonEncode(task.toJson());
  }).toList();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('tasks', tasksJson);
}
//تقرا البيانات
Future<void> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();

  final tasksJson = prefs.getStringList('tasks');

  if (tasksJson != null) {
    tasks.clear();

    for (final taskJson in tasksJson) {
      final taskMap = jsonDecode(taskJson);
      tasks.add(Task.fromJson(taskMap));
    }

    notifyListeners();
  }
}
}

//دالة لتحديد اتجاه الخط
TextDirection getTextDirection(String text) {
  for (final char in text.runes) {
    if ((char >= 0x0600 && char <= 0x06FF) ||
        (char >= 0x0750 && char <= 0x077F)) {
      return TextDirection.rtl;
    }

    if ((char >= 0x0041 && char <= 0x005A) ||
        (char >= 0x0061 && char <= 0x007A)) {
      return TextDirection.ltr;
    }
  }

  return TextDirection.ltr;
}
