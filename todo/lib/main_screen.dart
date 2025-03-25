import 'package:flutter/material.dart';
import 'package:todo/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Text('Drawer'),
      ),
      appBar: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,   // keyboard가 올라와서 bottomsheet를 가리므로, 그만큼을 padding으로 추가해야 됨
                    child: Container(
                      height: 250,
                      child: AddTask(),
                    ),
                  );
                },
              );
            }, 
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: const SizedBox(
        child: Text(''),
      ),
    );
  }
}
