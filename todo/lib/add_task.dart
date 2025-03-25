import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var todoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Add Task'),
          TextField(
            controller: todoTextController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: '할 일을 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0),),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              print(todoTextController.text);
              todoTextController.clear();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
