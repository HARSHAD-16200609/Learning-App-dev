import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'home_page.dart';

class intro_page extends StatelessWidget {
  const intro_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.grey[100],
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/nike-4-logo-svgrepo-com.svg',
              width: double.infinity,
              height: 305,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 100,
            ),
            Text("Just Do It",style: TextStyle(fontFamily: "times new roman",fontSize: 25,fontWeight: FontWeight.bold)),
            SizedBox(
              height: 12,
            ),
            Text("Brand new sneakers and fashion collections",style: TextStyle(fontFamily: "times new roman",fontSize: 15,color: Colors.grey)),
            SizedBox(
              height: 100,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: Padding(
                padding:  EdgeInsets.only(left: 22.0,right: 22.0),
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (
                            context,
                            ) => home_page(),
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),

                  child:Text("Shop Now",style: TextStyle(fontFamily: "times new roman",fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}