import 'package:flutter/material.dart';
import 'package:todoapp/utils/todo_tile.dart';

class home_page extends StatefulWidget {
   home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  List todolist = [

    ];
  final TextEditingController _taskController = TextEditingController();

  void checkboxChanged (index){
    setState(() {
      todolist[index][1] = !todolist[index][1];
    });
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  todolist.add([_taskController.text,false]);
                });
                Navigator.pop(context);
              },
              child:  Text("Save"),
            ),
          ],
        );
      },
    );
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(

          itemCount: todolist.length,
          itemBuilder: (context,index){
            return TodoTile(
              taskname: todolist[index][0],
              isChecked: todolist[index][1],
              onChanged: (value) =>checkboxChanged(index) ,
            );
        },),
      ),
      floatingActionButton: FloatingActionButton(
        shape:  CircleBorder(),
        onPressed:createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}


