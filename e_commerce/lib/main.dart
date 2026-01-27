import 'package:e_commerce/pages/cart.dart';
import 'package:e_commerce/pages/home_page.dart';
import 'package:e_commerce/pages/intro_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: intro_page(),
      
  
      routes: {
        '/intro': (context) => intro_page(),
        '/home': (context) => home_page(),
        '/cart': (context) => cart(),
      },
    );
  }
}
