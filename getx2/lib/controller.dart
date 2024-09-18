import 'package:get/get.dart';
import 'model.dart';

class Controller extends GetxController {
  final person = Person().obs;    // Person 인스턴스의 observable(Rx) 인스턴스

  void updateInfo() {
    person.update((val) {
      val?.age++;
      val?.name = 'Coding Chef';
    });
  }
}
