import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:Center(
        child:Container(
          child:Text(" Home Page of Auoniix Solutions",
            style: TextStyle(fontSize: 25),
        )
      )
      )
    );
  }
}