import 'package:flutter/material.dart';

class settingsPage extends StatelessWidget {
  const settingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Settings Page"),
        centerTitle: true,
      ),
    );
  }
}
