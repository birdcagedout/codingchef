// 코딩셰프 강의 GetX 2부 GetBuilder (Reactive state manager)
// Reactive: 변화된 값들을 observe하고 있다가 바로바로(=변화가 이루어진 후에 = 시간차 있음 = async) 반영한다의 의미
//           state가 지속적으로 변하는 경우에 사용한다.
// Rx: observable의 개념을 이용하여 변화를 적극 반영하는 개념
//     필연적으로 stream과 비슷한 형태, 다만 훨씬 편리한 api를 제공한다
// https://youtu.be/7M0ApRryXq4?si=IHFrniUIiT_f6yKc


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'person_view.dart';


void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: PersonView(),
    );
  }
}


