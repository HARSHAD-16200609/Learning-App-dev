import 'package:flutter/material.dart';

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
title: Text("TO DO"),
        elevation: 0,
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}