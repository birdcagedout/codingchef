// 코딩셰프 상태관리 Provider
// 강의1: https://youtu.be/-3iD7f3e_SU?si=mTUPwSdiNKXs8qjc
// 강의2: https://youtu.be/de6tAJS2ZG0?si=kwp93NBhNnYrI3j7



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider1/fish_model.dart';
import 'package:provider1/seafish_model.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FishModel(name: 'Salmon', number: 10, size: 'big'),),
        ChangeNotifierProvider(create: (context) => SeafishModel(name: 'Tuna', number: 0, size: 'middle'),),
      ],
      child: MaterialApp(
        home: FishOrder(),
      ),
    );
  }
}



class FishOrder extends StatelessWidget {
  const FishOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fish Order'),),
      body: Center(
        child: Column(
          children: [
            Text('Fish name: ${Provider.of<FishModel>(context).name}', style: TextStyle(fontSize: 20),),
            Text('Seafish name: ${Provider.of<SeafishModel>(context).name}', style: TextStyle(fontSize: 20),),
            SizedBox(height: 50,),
            High(),
          ],
        ),
      ),
    );
  }
}



class High extends StatelessWidget {
  const High({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('SpicyA is located at high place', style: TextStyle(fontSize: 16),),
        SizedBox(height: 20,),
        SpicyA(),
      ],
    );
  }
}



class SpicyA extends StatelessWidget {
  const SpicyA({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Fish number: ${Provider.of<FishModel>(context).number}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
        Text('Fish size: ${Provider.of<FishModel>(context).size}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        Middle(),
      ],
    );
  }
}



class Middle extends StatelessWidget {
  const Middle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('SpicyB is located at middle place', style: TextStyle(fontSize: 16),),
        SizedBox(height: 20,),
        SpicyB(),
      ],
    );
  }
}



class SpicyB extends StatelessWidget {
  const SpicyB({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Seafish number: ${Provider.of<SeafishModel>(context).number}', style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),),
        Text('Seafish size: ${Provider.of<SeafishModel>(context).size}', style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        ElevatedButton(
          child: Text('change seafish number'),
          onPressed: () {
            Provider.of<SeafishModel>(context, listen: false).changeSeafishNumber();
          },
        ),
        SizedBox(height: 20,),
        Low(),
      ],
    );
  }
}



class Low extends StatelessWidget {
  const Low({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('SpicyC is located at middle place', style: TextStyle(fontSize: 16),),
        SizedBox(height: 20,),
        SpicyC(),
      ],
    );
  }
}


class SpicyC extends StatelessWidget {
  const SpicyC({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Fish number: ${Provider.of<FishModel>(context).number}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
        Text('Fish size: ${Provider.of<FishModel>(context).size}', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),

        ElevatedButton(
          child: Text('change fish number'),
          onPressed: () {
            Provider.of<FishModel>(context, listen: false).changeFishNumber();
          },
        ),
      ],
    );
  }
}


