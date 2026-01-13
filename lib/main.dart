import 'package:flutter/material.dart';
import 'package:learningdart/pages/first_page.dart';
import 'package:learningdart/pages/second_page.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirstPage()
    );
  }
}
