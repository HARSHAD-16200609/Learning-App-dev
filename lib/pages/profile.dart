import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Container(
            child:Text("Welcome user to you profile",
                style: TextStyle(fontSize:25)
            )
        )
      ),
    );
  }
}