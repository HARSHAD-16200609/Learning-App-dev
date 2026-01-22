import 'package:flutter/material.dart';
import 'package:todoapp/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:home_page(),
    theme:ThemeData(
      primarySwatch: Colors.yellow,
        appBarTheme: const AppBarTheme(
      backgroundColor: Colors.yellow,
    )),

    );
  }
}

