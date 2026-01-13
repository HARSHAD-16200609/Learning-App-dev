import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: const Text("First Page"),
        centerTitle: true,
          actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        print("Logout clicked");
      },
    ),
  ],
      ),
      

    );

  }
}