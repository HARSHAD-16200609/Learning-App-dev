import 'package:flutter/material.dart';
import 'package:learningdart/pages/second_page.dart';

class FirstPage
    extends
        StatelessWidget {
  const FirstPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
        ),
        title: const Text(
          "First Page",
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () {
              print(
                "Logout clicked",
              );
            },
          ),
        ],
      ),

      body: Center(
        child: ElevatedButton(
          child: Text(
            "Go to Second Page",
            textScaler: TextScaler.linear(
              2,
            ),
          ),

          onPressed: () => Navigator.pushNamed(context,"/secondpage"),

          // Navigation to second page
        ),
      ),
    );
  }
}
