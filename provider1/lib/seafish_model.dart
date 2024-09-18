import 'package:flutter/material.dart';


class SeafishModel with ChangeNotifier {
  final String name;
  int number;
  final String size;

  SeafishModel({required this.name, required this.number, required this.size});


  void changeSeafishNumber() {
    this.number++;
    notifyListeners();
  }
}