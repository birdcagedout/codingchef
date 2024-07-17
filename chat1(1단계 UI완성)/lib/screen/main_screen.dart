import 'package:chat1/config/palette.dart';
import 'package:flutter/material.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool isSignupScreen = true;                 // 현재 상태(회원가입 or 로그인)
  final _formKey = GlobalKey<FormState>();    // Form키

  // 각 TextFormField의 값을 저장
  String userName = "";
  String userEmail = "";
  String userPassword = "";

  // validation error 개수
  int validationError = 0;

  void _tryValidation() {
    validationError = 0;
    final isValid = _formKey.currentState!.validate();  // Form 하위에 있는 TextFormField 요소들의 validator 실행(모두 null이면 true)
    if(isValid) {
      _formKey.currentState!.save();                    // 각 TextFormField의 onSave()를 호출
    } else {
      setState(() {
        // 폼필드의 에러 개수에 따라 상위 컨테이너의 높이 다르게
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        onTap: () {
          // FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            // 1. 빨간색 배경 그림
            Positioned(
              top: 0, right: 0, left: 0,
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20,),
                height: 300,
                decoration: const BoxDecoration(
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
                        style: const TextStyle(letterSpacing: 1, fontSize: 25, color: Colors.white,),
                        children: [
                          TextSpan(
                            text: isSignupScreen ? "to yummy chat" : "Back",
                            style: const TextStyle(letterSpacing: 1, fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold,),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    if(isSignupScreen) const Text("Sign up to continue", style: TextStyle(letterSpacing: 1, color: Colors.white,),),
                  ],
                ),
              ),
            ),

            // 2. 로그인/회원가입(TextFormField)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: 180,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
                width: MediaQuery.of(context).size.width - 40,
                // TextFormField에 error text가 없을 때=48, 있을 때=72
                height: isSignupScreen ? 280 + validationError * 24  : 220 + validationError * 24,
                padding: const EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 5,),
                  ],
                ),
                // 부모 위젯이 Animated...이고 줄어든 상태에서 커지는 상태로 갈 때, 순간적으로 자식들 크기가 줄어든 부모 크기보다 커지므로 RenderFlex overflowed 발생
                // 이것을 방지하기 위해서는 자식의 최상위에 SinglChildScrollView를 씌워준다
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 로그인(글자+밑줄)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                validationError = 0;
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen ? Palette.activeColor : Palette.textColor1,
                                  ),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    width: 55,
                                    height: 2,
                                    margin: EdgeInsets.only(top: 3),
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                          // 가입하기(글자+밑줄)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                validationError = 0;
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen ? Palette.activeColor : Palette.textColor1,
                                  ),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    width: 55,
                                    height: 2,
                                    margin: EdgeInsets.only(top: 3),
                                    color: Colors.orange,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Signup 화면
                      if (isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20,),
                          // The Form widget acts as a container for grouping and validating multiple form fields.
                          // Form: https://docs.flutter.dev/cookbook/forms/validation
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // 1) 사용자 이름
                                TextFormField(
                                  key: ValueKey(1),
                                  // Returns an error string to display if the input is invalid, or null otherwise
                                  validator: (String? value) {
                                    if(value == null || value.isEmpty || value.length < 3) {
                                      validationError++;
                                      return "Please enter a valid(at least 3 characters) name";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                    userName = value!;
                                  },
                                  decoration: const InputDecoration(
                                    // 입력필드 맨앞 아이콘
                                    prefixIcon: Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    // 입력필드 테두리
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 입력필드가 "포커스를 받을 때 테두리 상태" 그대로 유지(enableBorder값 copy)
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 힌트
                                    hintText: 'User name',
                                    hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1,),
                                    // 입력 내용과 테두리 사이 간격(디폴트=16)
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                // 2) 사용자 이메일
                                TextFormField(
                                  key: ValueKey(2),
                                  // Returns an error string to display if the input is invalid, or null otherwise
                                  validator: (String? value) {
                                    if(value == null || value.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                      validationError++;
                                      return "Please enter a valid Email address";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                    userEmail = value!;
                                  },
                                  decoration: const InputDecoration(
                                    // 입력필드 맨앞 아이콘
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    // 입력필드 테두리
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 입력필드가 "포커스를 받을 때 테두리 상태" 그대로 유지(enableBorder값 copy)
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 힌트
                                    hintText: 'Email',
                                    hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1,),
                                    // 입력 내용과 테두리 사이 간격(디폴트=16)
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                // 3) 사용자 비밀번호
                                TextFormField(
                                  key: ValueKey(3),
                                  // Returns an error string to display if the input is invalid, or null otherwise
                                  validator: (String? value) {
                                    if(value == null || value.isEmpty || value.length < 6) {
                                      validationError++;
                                      return "Password must be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                    userPassword = value!;
                                  },
                                  decoration: const InputDecoration(
                                    // 입력필드 맨앞 아이콘
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    // 입력필드 테두리
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 입력필드가 "포커스를 받을 때 테두리 상태" 그대로 유지(enableBorder값 copy)
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 힌트
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1,),
                                    // 입력 내용과 테두리 사이 간격(디폴트=16)
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Login 화면
                      if (!isSignupScreen)
                        Container(
                          margin: EdgeInsets.only(top: 20,),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // 1) 사용자 이메일
                                TextFormField(
                                  key: ValueKey(4),
                                  // Returns an error string to display if the input is invalid, or null otherwise
                                  validator: (String? value) {
                                    if(value == null || value.isEmpty || !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                                      validationError++;
                                      return "Please enter a valid Email address";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                    userEmail = value!;
                                  },
                                  decoration: const InputDecoration(
                                    // 입력필드 맨앞 아이콘
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    // 입력필드 테두리
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 입력필드가 "포커스를 받을 때 테두리 상태" 그대로 유지(enableBorder값 copy)
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 힌트
                                    hintText: 'Email',
                                    hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1,),
                                    // 입력 내용과 테두리 사이 간격(디폴트=16)
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                // 사용자 비밀번호
                                TextFormField(
                                  key: ValueKey(5),
                                  // Returns an error string to display if the input is invalid, or null otherwise
                                  validator: (String? value) {
                                    if(value == null || value.isEmpty || value.length < 6) {
                                      validationError++;
                                      return "Password must be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                    userPassword = value!;
                                  },
                                  decoration: const InputDecoration(
                                    // 입력필드 맨앞 아이콘
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    // 입력필드 테두리
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 입력필드가 "포커스를 받을 때 테두리 상태" 그대로 유지(enableBorder값 copy)
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Palette.textColor1,),
                                      borderRadius: BorderRadius.all(Radius.circular(15),),
                                    ),
                                    // 힌트
                                    hintText: 'Password',
                                    hintStyle: TextStyle(fontSize: 14, color: Palette.textColor1,),
                                    // 입력 내용과 테두리 사이 간격(디폴트=16)
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // 3. Submit 버튼(동그라미)
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              top: isSignupScreen ? 420 + validationError * 20: 360 + validationError * 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 5,),],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _tryValidation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.red,],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 1, spreadRadius: 1, offset: Offset(0,1),),
                        ],
                      ),
                      child: Icon(Icons.arrow_forward, color: Colors.white,),

                    ),
                  ),
                ),
              ),
            ),

            // 4. 기타 로그인(구글 로그인 등)
            Positioned(
              top: MediaQuery.of(context).size.height - 125,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text("or ${isSignupScreen ? "Signup" : "Login"} with"),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    icon: Icon(Icons.add),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(155, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Palette.googleColor,
                    ),
                    onPressed: () {

                    },
                    label: Text("Google",),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
