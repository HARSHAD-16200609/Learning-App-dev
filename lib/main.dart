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

              crossAxisAlignment: CrossAxisAlignment.center,

              children:[
                Expanded(
                    child:Container(

                        color: Colors.lightGreen
                    )
                ),
               Expanded(
                   child:Container(

                   color: Colors.lightBlue
               )
               ),
               Expanded(   // makes the container take all the space left out
                   flex:2,  // makes the widget n times grater than others like 2 or 3
                  child: Container(
                 color: Colors.pink,
               )
               ) ,

              ]
          )
      ),

    );
  }
}
