import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoTile extends StatelessWidget {
 final String taskname ;
 final bool isChecked;
Function (bool?)? onChanged;
Function (BuildContext)? deleteToDo;


   TodoTile({
     super.key, required this.taskname,
     required this.isChecked,required this.onChanged,
     required this.deleteToDo
   });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0, bottom: 8.0),
      child: Slidable(
        key: ValueKey(taskname),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: deleteToDo,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              Checkbox(value: isChecked, onChanged: onChanged),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  taskname,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: isChecked ? TextDecoration.lineThrough : null
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}