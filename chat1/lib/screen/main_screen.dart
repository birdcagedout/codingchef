import 'package:chat1/config/palette.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          // 1. 빨간색 배경 그림
          Positioned(
            top: 0, right: 0, left: 0,
            child: Container(
              padding: EdgeInsets.only(top: 90, left: 20,),
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/red.jpg'),
                  fit: BoxFit.fill,
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Welcome ",
                      style: TextStyle(letterSpacing: 1, fontSize: 25, color: Colors.white,),
                      children: [
                        TextSpan(
                          text: "to yummy chat",
                          style: TextStyle(letterSpacing: 1, fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold,),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text("Sign up to continue", style: TextStyle(letterSpacing: 1, color: Colors.white,),),
                ],
              ),
            ),
          ),

          // 2. 로그인/사인업
          Positioned(
            top: 180,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 280,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 5,),
                ],
              ),
              child: Column(
                children: [
                  Row(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
