import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  MyApp({super.key});
List names = ["Harshad","Vikrant","Suraj","Sumeet","Devesh","Omkar","Aryan","Siddharth","Aquibe","Anand"];

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
          // body:ListView.builder(  // used to build dynamic info containers
          //     itemCount:names.length,
          //     itemBuilder: (context,index)=>
          //     ListTile(  
          //       title:Text(names[index])
          //     ))
        body:GridView.builder(
          itemCount:64,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
            itemBuilder:(context,index)=> Container(
              margin:EdgeInsets.all(2),

              height:10,
             width:10,
             color:Colors.deepPurpleAccent
            )
      ),

      )
    );
  }
}
