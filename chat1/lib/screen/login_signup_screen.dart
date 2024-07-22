import 'dart:io';

import 'package:chat1/config/palette.dart';
import 'package:chat1/screen/chat_screen.dart';
import 'package:chat1/util/add_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';    // submit 버튼 후 spinner
import 'package:cloud_firestore/cloud_firestore.dart';                  // 인증시 extra data 전송 관련 처리 (firebase_auth 아님)
import 'package:firebase_storage/firebase_storage.dart';

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

  // firebase_auth
  final _auth = FirebaseAuth.instance;

  // submit 버튼 누른 후 spinner 보여주기
  bool showSpinner = false;

  // 프로파일용 이미지(카메라 사용)
  File? userImageFile;


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

  void getPickedImage(File image) {
    userImageFile = image;
  }

  void showPictureUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: AddImage(addImageFunc: getPickedImage,),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // 원래 포커스를 받는 위젯이 아닌 것을 터치하면 포커스를 죽여서 키보드를 없애는 방법
    // => "최상단 위젯"을 GestureDetector로 갑싸서 onTap에 한줄 넣는다
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
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
                                  Row(
                                    children: [
                                      Text(
                                        "SIGNUP",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isSignupScreen ? Palette.activeColor : Palette.textColor1,
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      if(isSignupScreen)
                                        GestureDetector(
                                          onTap: () {
                                            showPictureUploadDialog(context);
                                          },
                                          child: Icon(
                                            Icons.image,
                                            color: isSignupScreen
                                                ? Colors.cyan
                                                : Colors.grey[300],
                                          ),
                                        ),
                                    ],
                                  ),
                                  // 밑줄
                                  if (isSignupScreen)
                                    Container(
                                      width: 55,
                                      height: 2,
                                      margin: EdgeInsets.fromLTRB(0, 3, 35, 0),
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
                                    onChanged: (value) {
                                      userName = value;
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
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    onSaved: (value) {
                                      // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                      userEmail = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
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
                                    obscureText: true,
                                    key: ValueKey(3),
                                    // Returns an error string to display if the input is invalid, or null otherwise
                                    validator: (String? value) {
                                      if(value == null || value.isEmpty || value.length < 6) {
                                        validationError++;
                                        return "Password must be at least 6 characters long";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
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
                                    onChanged: (value) {
                                      userEmail = value;
                                    },
                                    onSaved: (value) {
                                      // _formKey.currentState.save()가 호출되면 각 TextFormField에 남아있는 String값이 value로 넘어오면서 onSave 호출됨
                                      userEmail = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
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
                                    obscureText: true,
                                    key: ValueKey(5),
                                    // Returns an error string to display if the input is invalid, or null otherwise
                                    validator: (String? value) {
                                      if(value == null || value.isEmpty || value.length < 6) {
                                        validationError++;
                                        return "Password must be at least 6 characters long";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      userPassword = value;
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
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? 420 + validationError * 20: 360 + validationError * 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15, spreadRadius: 5,),],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        // submit 버튼을 누른 직후 spinner 보임
                        setState(() {
                          showSpinner = true;
                        });

                        // 회원가입
                        if(isSignupScreen) {

                          // 이미지 파일이 있어야만 회원가입 가능
                          if(userImageFile == null) {
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("[ERROR] Pick your profile image", style: TextStyle(color: Colors.black),),
                                backgroundColor: Colors.amber,
                              ),
                            );
                            return;
                          }

                          _tryValidation();

                          try {
                            final newUser = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

                            // 이미지 경로 설정
                            final refImage = FirebaseStorage.instance
                                .ref()
                                .child('picked_image')
                                .child("${newUser.user!.uid}.png");

                            // 이미지 업로드
                            await refImage.putFile(userImageFile!);

                            // 업로드한 이미지의 URL 저장
                            final imageURL = refImage.getDownloadURL();

                            // 회원가입 시 extra data 전송
                            // firestore db는 항상 collection-doc-필드데이터 구조
                            // collection('user')은 미리 생성할 필요없고, 필드데이터는 항상 Map 형태임에 유의
                            await FirebaseFirestore.instance.collection('user').doc(newUser.user!.uid).set(
                              {
                                'userName'  : userName,
                                'userEmail' : userEmail,
                                'picked_image' : imageURL,
                              },
                            );

                            if (newUser.user != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatScreen();
                                  }
                                ),
                              );

                              // 이상 없이 회원가입이 끝난 경우
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch(e) {
                            print(e);

                            /* 아래와 같이 if(mounted) {} 사용하지 않으면 에러 발생
                              [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Looking up a deactivated widget's ancestor is unsafe.
                              At this point the state of the widget's element tree is no longer stable.
                              To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.
                              #0      Element._debugCheckStateIsActiveForAncestorLookup.<anonymous closure> (package:flutter/src/widgets/framework.dart:4743:9)
                              #1      Element._debugCheckStateIsActiveForAncestorLookup (package:flutter/src/widgets/framework.dart:4757:6)
                              #2      Element.findAncestorWidgetOfExactType (package:flutter/src/widgets/framework.dart:4818:12)
                              #3      debugCheckHasScaffoldMessenger.<anonymous closure> (package:flutter/src/material/debug.dart:175:17)
                              #4      debugCheckHasScaffoldMessenger (package:flutter/src/material/debug.dart:187:4)
                              #5      ScaffoldMessenger.of (package:flutter/src/material/scaffold.dart:146:12)
                              #6      _LoginSignupScreenState.build.<anonymous closure> (package:chat1/screen/login_signup_screen.dart:549:49)
                              <asynchronous suspension>
                            */

                            if(mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("[ERROR] Check your email and password", style: TextStyle(color: Colors.black),),
                                  backgroundColor: Colors.amber,),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          }
                        }

                        // 로그인
                        else {
                          _tryValidation();

                          try {
                            final newUser = await _auth.signInWithEmailAndPassword(email: userEmail, password: userPassword);

                            if(newUser.user != null) {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return ChatScreen();
                              //     },
                              //   ),
                              // );

                              // 이상 없이 로그인이 끝난 경우
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          } catch(e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("[ERROR] Check your email and password", style: TextStyle(color: Colors.black),), backgroundColor: Colors.amber,),
                            );
                          }
                        }

                        // print("name: $userName, email: $userEmail, password: $userPassword");

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.red,],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 1, spreadRadius: 1, offset: Offset(0,1),),
                          ],
                        ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white,),

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
      ),
    );
  }
}
