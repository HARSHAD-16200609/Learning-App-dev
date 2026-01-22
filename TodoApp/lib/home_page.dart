import 'package:flutter/material.dart';
import 'package:todoapp/utils/todo_tile.dart';

class home_page extends StatefulWidget {
   home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
backgroundColor: Colors.yellow[300],
      appBar: AppBar(
        centerTitle: true,
title: Text("TODO APP 📝"),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(25),

        children: [
          TodoTile(taskname: 'Buy Groceries 🍅', isChecked: true,),
          TodoTile(taskname: 'Do Homework 📚', isChecked: false,),
          TodoTile(taskname: 'Study Flutter ❤️‍🔥', isChecked: true,),
          TodoTile(taskname: 'Drink Whiskey 🍺', isChecked: false,),
          TodoTile(taskname: 'Go to gym 💪', isChecked: true,),
          TodoTile( taskname: ' Do Programming 🧑‍🏫', isChecked: false,),



        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){print("TODO added Sucessfully");},
        child: Icon(Icons.add),
      ),
    );
  }
}

