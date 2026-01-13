import 'package:flutter/material.dart';

import 'first_page.dart';

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
alignment: Alignment.bottomCenter,
          children: [
            Container(
              alignment: Alignment.center,
              height: 200,
              width: 300,

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
              child: Text(
                "I am the Second Page",
                textScaler: TextScaler.linear(
                  2,
                ),
                selectionColor: Colors.cyan[300],
              ),
            ),

            Container(
              child:ElevatedButton(
                child: Text("Go to First Page"),
                  onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context) => FirstPage()))
            )
        ),
          ],
      ),
    )
    );
  }
}
