import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class home_page extends StatelessWidget {
  const home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
title: Text("N I K E",
style: TextStyle(fontFamily: "times new roman"),),

      ),
      drawer: Drawer(
backgroundColor: Colors.white,

      child:Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
              children:[

                SvgPicture.asset(
                  'lib/assets/nike.svg',
                  width: 160,
                  height: 160,
                ),
              ListTile(
                leading:Icon(Icons.home,size:25),
                title: Text("H O M E",style: TextStyle(fontFamily: "times new roman")),
              )
              ]
          ),
        ),
      )
      ),
      body:Center(
        child:Expanded(
          child: Container(
            color: Colors.white,
            child:Center(child:Text(
              "Home Page",
              style: TextStyle(
                fontFamily: "times new roman",
                color: Colors.black,
                fontSize: 20,
              ),
            ))
        ),)

      )
    );
  }
}