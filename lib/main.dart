import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});
List names = ["Harshad","Vikrant","Suraj","Sumeet","Devesh","Omkar","Aryan","Siddharth","Aquibe","Anand"];

void displayUsers (){
  for (var name in names) {
    print(name);
  }
}

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

        // examplle of nested childs
        // body:Center (
        //   child : GestureDetector(
        //     child:Expanded(
        //         child:Container(
        //       color: Colors.blue[600],
        //       height: 200,
        //       child: Center(
        //           child:Text(
        //               "My name is Harshad",
        //             textScaler: TextScaler.linear(2),
        //           )),
        //
        //
        //     ))
        //   )
        //    ),
          body:Center (
              child : GestureDetector(
                onTap: () =>displayUsers(),
                      child:Container(
                        color: Colors.purple[600],
                        height: 200,
                        child: Center(
                            child:Text(
                              "My name is Harshad",
                              textScaler: TextScaler.linear(2),
                            )),


                      )
              )
          )

      )
    );
  }
}
