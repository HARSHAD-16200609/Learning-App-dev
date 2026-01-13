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
          // body:Column (
          //
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //
          //     children:[
          //       Container(
          //         height:300,
          //         color: Colors.lightGreen,
          //
          //       ),
          //       Container(
          //           height:300,
          //         color: Colors.lightBlue
          //       ),
          //       Container(
          //         // 3rd box dosen't fit
          //        height:300,
          //         color: Colors.pink,
          //       ),
          //
          //     ]
          // )
          body:ListView( // used because gives us the overflow scroll property unlike column
            scrollDirection: Axis.horizontal,  // makes scroll horizontal
            //   scrollDirection: Axis.vertical,     // makes scroll vertical default
              children:[
                    Container(
                      height:300,
                      width:300,
                      color: Colors.lightGreen,

                    ),
                    Container(
                        height:300,
                        width:300,

                        color: Colors.lightBlue
                    ),
                    Container(

                     height:300,
                      width:300,

                      color: Colors.pink,
                    ),
            ]
          )
      ),


    );
  }
}
