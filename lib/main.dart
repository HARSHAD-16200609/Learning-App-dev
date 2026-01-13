import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});
String name  = "harshad";
int age = 19;
bool isBeginner = true;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
          appBar: AppBar(
            title:Text("My App Bar"),
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            elevation: 0,
            leading:Icon(Icons.menu),
            actions:[
IconButton(onPressed: ()=>{
  print("clicked")
},
icon:Icon(Icons.logout))
            ],

          ),
          body:Column (
              children:[
                Container(
                  height:200,
                  width:600,
                  color: Colors.lightGreen,

                ),
                Container(
                  height:200,
                  width:600,
                  color: Colors.lightBlue
                ),
                Container(
                  height:200,
                  width:600,
                  color: Colors.pink,
                ),

              ]
          )
      ),

    );
  }
}
