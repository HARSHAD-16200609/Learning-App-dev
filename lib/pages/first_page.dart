import 'package:flutter/material.dart';
import 'package:learningdart/pages/profile.dart';

import 'package:learningdart/pages/settingsPage.dart';

import 'HomePage.dart';

class FirstPage
    extends
        StatefulWidget {
   FirstPage({
    super.key,
  });

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
   int _selectedindex = 0;

  final List _pages
  =[
    //homepage
    HomePage(),
    //profile page
    Profile(),
    //settings page
    settingsPage(),
  ];

  void navigateBottomBar(int index){
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "First Page",
        ),
        centerTitle: true,
backgroundColor: Colors.lightBlue,

      ),
      drawer: Drawer(
        backgroundColor: Colors.cyanAccent[100],
       child:Column(
  children: [
    DrawerHeader(child: Icon(Icons.favorite,size: 50,
    ) ),
   ListTile(
     leading: Icon(Icons.home,size:25),
     title:Text("H O M E"),
       onTap:()=> Navigator.pushNamed(context,"/profilepage")
   ),
   ListTile(
     leading: Icon(Icons.settings,size:25),
     title:Text("S E T T I N G S"),
       onTap:()=> Navigator.pushNamed(context,"/settingspage")
   ),
   ListTile(
     leading: Icon(Icons.logout,size:25),
     title:Text("L O G O U T"),
   ),
   ListTile(
     leading: Icon(Icons.contact_mail,size:25,),
     title:Text("A B O U T  U S"),
     onTap:()=> Navigator.pushNamed(context,"/secondpage")
   )
  ],

    ),


        ),
      body: _pages[_selectedindex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedindex,
        onTap: navigateBottomBar,
        items:[
      BottomNavigationBarItem(
          icon:Icon(Icons.home),
          label:'Home',

      ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.person),
              label:'Profile',
          ),
          BottomNavigationBarItem(

              icon:Icon(Icons.settings),
              label:'settings'
          )

        ],
      ),




    );
  }
}
