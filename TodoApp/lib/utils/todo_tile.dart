import 'package:flutter/material.dart';

class TodoTile extends StatelessWidget {
 final String taskname ;
 final bool isChecked;
Function (bool?)? onChanged;

   TodoTile({super.key, required this.taskname, required this.isChecked,required this.onChanged});



  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(top:20),
      height: 100,
      width: 100,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],

      ),
      child: Row(
        children: [
          Checkbox(value: isChecked, onChanged: onChanged),
          SizedBox(width: 20,),
          Text(taskname,style: TextStyle(fontSize: 20,decoration: isChecked ? TextDecoration.lineThrough : null)),

        ],
      ),
    );;
  }
}