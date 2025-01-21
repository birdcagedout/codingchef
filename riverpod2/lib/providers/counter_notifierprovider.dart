import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 생성 ==> StateProvider보다 복잡한 상태(단순히 int나 String형 변수 1개가 아니라)를 관리하기 위해서는 NotifierProvider 사용
final counterNotifierProvider = NotifierProvider();

// 상태를 관리하기 위한 클래스
// StateProvider에서는 상태가 단순한 타입의 변수 1개였을 뿐이지만,
// 만약 상태가 복잡한 형태라면 그러한 상태를 관리할 "비즈니스 로직"을 담고 있는 class가 필요하다.
class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }
}