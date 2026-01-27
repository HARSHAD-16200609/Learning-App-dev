import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class home_page extends StatefulWidget {
   home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  List images = ['5daa00d9_afae_4125_a95c_fc71923b81c3.webp','447ce43b_9ffb_49ca_b1af_ba209877be22.webp','b5bf7176_9aaa_4e63_8bcd_50f809fc1dab.webp','e6da41fa_1be4_4ce5_b89c_22be4f1f02d4.webp','NK_NKHQ4614_101_198726385898_1.webp','NK_NKIM0542_100_198728663048_1.webp'];
  
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [ SvgPicture.asset(
            'assets/images/nike-4-logo-svgrepo-com.svg',
            width: 35,
            height: 35,
          ),
            SizedBox(width: 8),
            Text("N I K E",
              style: TextStyle(fontFamily: "times new roman"),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child:Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                SvgPicture.asset(
                  'assets/images/nike-4-logo-svgrepo-com.svg',
                  width: 160,
                  height: 160,
                ),
                ListTile(
                  leading:Icon(Icons.home,size:25),
                  title: Text("H O M E",style: TextStyle(fontFamily: "times new roman")),
                ),
                ListTile(
                  leading:Icon(Icons.shopping_cart,size:25),
                  title: Text("C A R T",style: TextStyle(fontFamily: "times new roman")),
                ),
                ListTile(
                  leading:Icon(Icons.info,size:25),
                  title: Text("A B O U T ",style: TextStyle(fontFamily: "times new roman")),
                )
              ]
            ),
          ),
        )
      ),
      body: Column(
        children: [
          // PageView for swipeable full images
          Expanded(

            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/${images[index]}',
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Page indicators

        ],
      ),
    );
  }
}