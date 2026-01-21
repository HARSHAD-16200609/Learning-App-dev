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
      body: Center(
        child:Container(
          child:Text("Welcome to Aurionix Solutions",
              style: TextStyle(fontSize:25)
        )
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
