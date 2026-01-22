import 'package:flutter/material.dart';

class todoPage extends StatefulWidget {
   todoPage({super.key});

  @override
  State<todoPage> createState() => _todoPageState();
}

class _todoPageState extends State<todoPage> {
   TextEditingController myController = TextEditingController();

   String greetingmessage ="";

void greetUser (){
  String username = myController.text;
  setState(() {
    greetingmessage = "Hello, "+username;
  });

}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

  body:Center(

    child:Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(

      mainAxisAlignment: MainAxisAlignment.center,
        children: [

Text(greetingmessage),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Your Name..."
            ),
           controller: myController,

         ) ,

          ElevatedButton(
            onPressed: () => greetUser(),
            child:  Text("Submit"),
          )



        ],
      ),
    )
  )
    );
  }
}