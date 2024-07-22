import 'package:chat1/chatting/chat/old_message.dart';
import 'package:chat1/chatting/chat/new_massage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if(user != null) {
        loggedUser = user;
        print("loggedUser.email: ${loggedUser!.email}");
      }
    } catch(e) {
      // 현재 로그인된 유저가 없는 경우 Exception 발생
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "[ERROR] currentUser를 가져올 수 없습니다",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.amber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat Screen(${loggedUser!.email})"),
          actions: [
            IconButton(
              onPressed: () {
                _auth.signOut();
                // Navigator.of(context).pop();
                print("로그아웃 성공");
              },
              icon: const Icon(Icons.exit_to_app_sharp, color: Colors.black,),
            ),
          ],
        ),

        // 채팅부분 완성 전까지 firestore의 db정보 확인하는 용도로 사용함
        // body: StreamBuilder(
        //   stream: FirebaseFirestore.instance.collection("chats/tGdAs5S9PrW2dQLeYfaz/message").snapshots(),
        //   // builder로 들어오는 snapshot은 collection의 snapshot이므로
        //   // snapshot.data는 collection이다
        //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //     // 연결되기 전까지
        //     if(snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //
        //     // 연결되었는데도 data가 없는 경우
        //     if(snapshot.data == null) {
        //       return Container();
        //     }
        //
        //     return ListView.builder(
        //       itemCount: snapshot.data!.docs.length,
        //       itemBuilder: (context, index) {
        //         return Container(
        //           padding: const EdgeInsets.all(8),
        //           child: Text(snapshot.data!.docs[index]['text'], style: const TextStyle(fontSize: 20),),
        //         );
        //       },
        //     );
        //   },
        // ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Expanded(child: Messages(),),
                NewMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
