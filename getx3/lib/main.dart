import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx3/view/shopping_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetX 실전1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShoppingPage(),
    );
  }
}



