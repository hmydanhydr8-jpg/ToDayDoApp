import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_data.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tasks"),
        backgroundColor: const Color.fromARGB(151, 4, 231, 122),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: taskData.tasks.length,
        itemBuilder: (context, index) {
          return InkWell(
            onLongPress: () {
              showModalBottomSheet(
                constraints: BoxConstraints(maxHeight: 200),
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("1 - Deleate", style: TextStyle(fontSize: 26)),
                            IconButton(
                              onPressed: () {
                                taskData.deleteTask(index);
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "2 - Edit Text",
                              style: TextStyle(fontSize: 26),
                            ),
                            IconButton(
                              onPressed: () {
                                final controller = TextEditingController(
                                  text: taskData.tasks[index].name,
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: Text("Edite Task:"),
                                          content: TextField(
                                            controller: controller,

                                            textDirection: getTextDirection(
                                              controller.text,
                                            ),
                                            onChanged: (value) {
                                              setDialogState(() {});
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                taskData.editTask(
                                                  index,
                                                  controller.text,
                                                );
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Save"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: CheckboxListTile(
              activeColor: Colors.amber,
              value: taskData.tasks[index].isDone,
              onChanged: (value) {
                taskData.toggleTask(index);
              },
              title: Column(
                children: [
                  Align(
                    alignment:
                        getTextDirection(taskData.tasks[index].name) ==
                            TextDirection.rtl
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Text(
                      taskData.tasks[index].name,
                      textDirection: getTextDirection(
                        taskData.tasks[index].name,
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        decoration: taskData.tasks[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    title: Text("Add Task:"),
                    content: TextField(
                      controller: controller,

                      textDirection: getTextDirection(controller.text),
                      onChanged: (value) {
                        setDialogState(() {});
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          taskData.addNewTask(controller.text);
                          Navigator.pop(context);
                        },
                        child: Text("Add"),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add, size: 38),
      ),
    );
  }
}
