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
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              height: 300,
              width: 300,

              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  16,
                ),
              ),
              child: Text(
                "Aurionix Solutions is a forward-thinking technology company."
                    "We focus on innovation, scalability, and quality."
                    "Our mission is to deliver future-ready digital solutions."
              ,
                textScaler: TextScaler.linear(
                  1.5,
                ),
                selectionColor: Colors.cyan[300],
              )
        ),


            Container(
              margin: EdgeInsets.only(top:6),
              child:ElevatedButton(
                child: Text("Go to Home Page"),
                  onPressed:()=> Navigator.pushNamed(context,"/firstpage")
            )
        ),
          ],
      ),
    )
    );
  }
}
