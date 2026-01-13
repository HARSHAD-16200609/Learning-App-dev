import 'package:flutter/material.dart';

class secondPage
    extends
        StatelessWidget {
  const secondPage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
alignment: Alignment.center,
              height: 200,
              width: 300,
              child: Text(
                "I am the Second Page",
                textScaler: TextScaler.linear(
                  2,
                ),
                selectionColor: Colors.cyan[300],
              ),

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
