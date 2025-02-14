import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider 생성 ==> StateProvider보다 복잡한 상태(단순히 int나 String형 변수 1개가 아니라)를 관리하기 위해서는 NotifierProvider 사용
// Notifier라는 상태관리클래스(=상태)를 제공하기 위한 provider
// 제네릭으로 이렇게 선언한다 ==> <상태관리클래스의 타입, 상태의 본질인 Notifier의 제네릭 타입>
// 인자로 상태관리클래스(Notifier 타입)의 인스턴스를 넘겨주기 위해 .new 사용
final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

// 상태를 관리하기 위한 클래스 = 상태 그 자체
// StateProvider에서는 상태가 단순한 타입의 변수 1개였을 뿐이지만,
// 만약 상태가 복잡한 형태라면 그러한 "상태"를 관리할 "비즈니스 로직"을 담고 있는 class(=상태 관리 클래스)가 필요하다. ==> 그 "상태 관리 클래스"는 Notifier 클래스를 상속한 클래스로 만들어준다
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