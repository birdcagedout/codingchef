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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Screen"),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.of(context).pop();
              print("로그아웃 성공");
            },
            icon: const Icon(Icons.exit_to_app_sharp, color: Colors.black,),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("chats/tGdAs5S9PrW2dQLeYfaz/message").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          // 연결되기 전까지
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // 연결되었는데도 data가 없는 경우
          if(snapshot.data == null) {
            return Container();
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(8),
                child: Text(docs[index]['text'], style: TextStyle(fontSize: 20),),
              );
            },
          );
        },


      ),
    );
  }
}
