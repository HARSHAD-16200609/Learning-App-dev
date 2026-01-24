import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/utils/todo_tile.dart';

import 'data/database.dart';

class home_page extends StatefulWidget {
   home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
final _myBox= Hive.box('mybox');

Database db = Database();

  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If this is the first time opening the app, create default data
    if (_myBox.get('todolist') == null) {
      db.createInitialData();
    } else {
      // Data already exists, load it
      db.loadData();
    }
  }

  void checkboxChanged (index){
    setState(() {
      db.todolist[index][1] = !db.todolist[index][1];
    });
    db.updateData();
  }
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text("Add Task"),
          content: TextField(
            controller: _taskController,
            decoration:  InputDecoration(
              hintText: "Enter task name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  db.todolist.add([_taskController.text,false]);
                });
                db.updateData();
                _taskController.clear();
                Navigator.pop(context);
              },
              child:  Text("Save"),
            ),
          ],
        );
      },
    );
  }
void deleteTask (index){
  setState(() {
    db.todolist.removeAt(index);
  });
  db.updateData();
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
backgroundColor: Colors.yellow[300],
      appBar: AppBar(
        centerTitle: true,
title: Text("TODO APP 📝"),
        elevation: 0,
      ),
      body: SlidableAutoCloseBehavior(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: db.todolist.length,
            itemBuilder: (context,index){
              return TodoTile(
                key: ValueKey(db.todolist[index][0] + index.toString()),
                taskname: db.todolist[index][0],
                isChecked: db.todolist[index][1],
                onChanged: (value) =>checkboxChanged(index) ,
                deleteToDo: (context) => deleteTask(index)
              );
          },),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape:  CircleBorder(),
        onPressed:createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}


