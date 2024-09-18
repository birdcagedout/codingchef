// 코딩셰프 강의 GetX 1부 GetBuilder (Simple state manager)
// pub.dev에는 get으로 검색해야 나온다
// https://youtu.be/9_lJrJ0yVbg?si=oNdZVNBBrzUTY_jG



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx1/controller.dart';



void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 방법1
    // Controller의 인스턴스를 Get에 등록시킴(Dependency injection)
    // 리턴값은 등록시킨 Controller 인스턴스
    // Controller controller = Get.put(Controller());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('GetX'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 방법2
              // GetBuilder의 init에 Controller 인스턴스를 직접 줄 수도 있다.
              // 단, 이 경우에는 코드의 나머지 부분에서 Controller 인스턴스에 직접 접근할 방법이 없으므로
              // Get.find<Controller>()의 방법으로 인스턴스에 접근해야 한다.
              GetBuilder<Controller>(
                init: Controller(),
                // builder: (_) => Text('Current value: ${controller.x}', style: TextStyle(fontSize: 20, color: Colors.red),),
                builder: (_) => Text('Current value: ${Get.find<Controller>().x}', style: TextStyle(fontSize: 20, color: Colors.red),),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                child: Text('Add number'),
                onPressed: () {
                  // controller.increment();
                  Get.find<Controller>().increment();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
