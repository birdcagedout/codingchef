import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod2/providers/counter_notifierprovider.dart';
import 'providers/counter_stateprovider.dart';


// Consumer 위젯(ConsumerStatefulWidget, ConsumerState, ConsumerState 수정 필요)
// Roverpod의 provider로부터 상태를 구독하고 즉각 UI 업데이트 가능하게 함
class CounterPage extends ConsumerStatefulWidget {
  const CounterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CounterPageState();
}

class _CounterPageState extends ConsumerState<CounterPage> {
  // 1. 버튼의 콜백 내에서 setState를 사용하는
  // Riverpod을 사용하지 않은 기존 방식을 보여주기 위한 변수
  // int counter = 0;


  @override
  Widget build(BuildContext context) {
    // 2. Riverpod의 StateProvider를 불러와서 사용할 수 있다
    // ref를 통해 Provider의 상태를 구독하고, 값이 변경되면 구독한 consumer의 build를 실행한다
    // ref는 반드시 build()의 내부에 위치해야 ref를 참조할 수 있다. ==> ref의 실체는 ConsumerState의 buildcontext이기 때문
    // final counter = ref.watch(counterProvider);

    // 새로운 상태 받아오기
    final counter = ref.watch(counterNotifierProvider);


    return Scaffold(
      appBar: AppBar(title: Text('Riverpod Part1'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Number count: $counter', style: TextStyle(fontSize: 20,),),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  print("Plus");
                  // setState(() {
                  //   counter++;
                  // });

                  // provider쪽 상태에 접근해서 값을 변경
                  // ref.read(counterProvider.notifier).state++;
                  // print('${ref.read(counterProvider.notifier).state}(으)로 변경됨');

                  // 괄호 안(=상태의 인스턴스)을 읽어와서 증가시킴
                  ref.read(counterNotifierProvider.notifier).increment();

                },
                child: Text('Plus'),
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  print("Minus");
                  // setState(() {
                  //   counter--;
                  // });

                  // provider쪽 상태에 접근해서 값을 변경
                  // ref.read(counterProvider.notifier).state--;
                  // print('${ref.read(counterProvider.notifier).state}(으)로 변경됨');

                  // 괄호 안(=상태의 인스턴스)을 읽어와서 감소시킴
                  ref.read(counterNotifierProvider.notifier).decrement();
                },
                child: Text('Minus'),
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed: () {
                  print("Reset");

                  // 괄호 안(=상태의 인스턴스)을 읽어와서 리셋
                  ref.read(counterNotifierProvider.notifier).reset();
                },
                child: Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
