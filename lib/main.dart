import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('My Tasks'),
            actions: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: const Tooltip(
                    message: 'Groups Info',
                    child: Padding(
                      padding: EdgeInsets.all(19.0),
                      child: Icon(Icons.error_outline),
                    ),
                  ),
                  onTap: () {
                    _groupsInfo(context);
                  },
                ),
              ),
            ],
          ),
          body: GetContent(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _addTask(context);
            },
            tooltip: 'Add task',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _groupsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: Text(
            'Dari Kelompok 5:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            constraints: BoxConstraints(
              maxWidth: 350.0, // Ganti dengan lebar maksimum yang Anda inginkan
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('1. Mochamad Darmawan. H (0618101098)'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('2. Muhammad Adyaputra. Y (0619101050)'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('3. Mega Maudi. A (40621100011)'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('4. Raudiah Rahadatul Fitriani. H (40621100013)'),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('5. Sema Oktaviani Tinting (0619101018)'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      Text(
                        'Aplikasi ini dibuat untuk memenuhi salah satu tugas besar dari matakuliah',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Text(
                        'Pemograman Berorientasi Objek 2',
                        style: TextStyle(
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'yang dibimbing oleh dosen Bapak Kunia Jaya Eliazar, S.T., M.T..',
                        style: TextStyle(color: Colors.black45),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Aplikasi ini dibuat pada tanggal 01 Mei 2023 - 06 Juni 2023.',
                          style: TextStyle(color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addTask(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String? newTask;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: Text(
            'Add New Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newTask = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Data data = SharedPreferencesData();

                      List<String> tasks = await data.getData();

                      DateTime currentTime = DateTime.now();
                      String task = '$newTask - $currentTime - false';

                      tasks.add(task);
                      await data.saveData(tasks);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MainApp(),
                        ),
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Success',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text('Task added successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class GetContent extends StatelessWidget {
  Future<List<String>> _getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<String> tasks = snapshot.data ?? [];

          return TodoContent(tasks: tasks);
        }
      },
    );
  }
}

class TodoContent extends StatefulWidget {
  final List<String> tasks;

  const TodoContent({required this.tasks});

  @override
  _TodoContentState createState() => _TodoContentState();
}

class _TodoContentState extends State<TodoContent> {
  late List<bool> isCheckedList;

  @override
  void initState() {
    super.initState();
    isCheckedList = List.generate(widget.tasks.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> tasks = widget.tasks;

    if (tasks.isEmpty) {
      return Center(
        child: Text('No data'),
      );
    }

    return Padding(
      padding: EdgeInsets.all(19.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                List<String> parts = tasks[index].split(' - ');
                String task = parts[0];
                String timestamp = parts[1];
                String isDone = parts[2];

                isCheckedList[index] = isDone == "false" ? false : true;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black12,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: [
                          Tooltip(
                            message: 'Mark as Done',
                            child: Checkbox(
                              value: isCheckedList[index],
                              onChanged: (newValue) {
                                setState(() {
                                  isCheckedList[index] = newValue ?? false;
                                  _updateTaskStatus(index, newValue!);
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  "${task}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "${timestamp}",
                                    style: TextStyle(fontSize: 13.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.edit_square),
                            color: Colors.blue,
                            onPressed: () {
                              _editTask(context, index);
                            },
                            tooltip: 'Edit task',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _deleteTask(context, index);
                            },
                            tooltip: 'Delete task',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateTaskStatus(int index, bool isChecked) async {
    Data data = SharedPreferencesData();

    List<String> tasks = await data.getData();

    List<String> taskParts = tasks[index].split(' - ');
    String task = taskParts[0];
    DateTime time = DateTime.parse(taskParts[1]);
    String status = isChecked ? 'true' : 'false';

    String updatedTask = '$task - $time - $status';
    tasks[index] = updatedTask;

    await data.saveData(tasks);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MainApp(),
      ),
    );
  }

  void _editTask(BuildContext context, int index) async {
    Data data = SharedPreferencesData();

    List<String> tasks = await data.getData();

    List<String> taskParts = tasks[index].split(' - ');
    String task = taskParts[0];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        String? editedTask;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: Text(
            'Edit Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: task,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      editedTask = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      tasks[index] =
                          '$editedTask - ${taskParts[1]} - ${taskParts[2]}';

                      await data.saveData(tasks);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MainApp(),
                        ),
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Success',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text('Task edited successfully!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _deleteTask(BuildContext context, int index) async {
    Data data = SharedPreferencesData();

    List<String> tasks = await data.getData();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          title: Text(
            'Delete Task',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                tasks.removeAt(index);
                await data.saveData(tasks);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MainApp(),
                  ),
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Success',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text('Task deleted successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
