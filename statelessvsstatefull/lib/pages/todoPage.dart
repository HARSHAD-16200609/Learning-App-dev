import 'package:flutter/material.dart';

class todoPage extends StatefulWidget {
   todoPage({super.key});

  @override
  State<todoPage> createState() => _todoPageState();
}

class _todoPageState extends State<todoPage> {
   TextEditingController myController = TextEditingController();
void greetUser (){
  print("Hello "+myController.text);
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

  body:Center(

    child:Column(

      children: [
      Container(
        margin:EdgeInsets.only(top :250.0),
        padding:EdgeInsets.all(10),

       child: TextField(
          controller: myController,

        ),
      ),
        ElevatedButton(
          onPressed: () => greetUser(),
          child: const Text("Submit"),
        )



      ],
    )
  )
    );
  }
}