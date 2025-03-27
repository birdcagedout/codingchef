import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key, required this.addTodo});

  final void Function({required String todoText}) addTodo;

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
            autofocus: true,
            onSubmitted: (todoText) {   // textfield에서 Enter가 입력되면 바로 동작 + 키보드와 bottomsheet 제거
              widget.addTodo(todoText: todoTextController.text);
              todoTextController.clear();
            },
            decoration: InputDecoration(
              labelText: '할 일을 입력하세요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0),),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // print('[${todoTextController.text}]');     // textfield에 입력이 없는 경우 ''문자가 들어온다(null 아님)
              widget.addTodo(todoText: todoTextController.text);
              todoTextController.clear();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
