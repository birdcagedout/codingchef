import 'package:get/get.dart';

class Controller extends GetxController {
  int _x = 0;
  int get x => _x;

  void increment() {
    _x++;
    update();   // 반드시 해주어야 GetBuilder가 UI를 rebuild한다
  }
}