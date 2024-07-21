import 'package:chat1/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)    // 오래된거=작은값, 최신거=큰값 ==> 최신꺼가 첫번째 item이어야한다
          .snapshots(),
      // builder에 들어오는 snapshot = collection의 snapshot이므로
      // snapshot.data는 collection('chat')이다
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // 연결 중일 때
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 연결되었는데도 data가 없을 때
        if(snapshot.data == null) {
          return Container();
        }

        return ListView.builder(
          // false: top to bottom(=마지막), true: bottom to top(=마지막)
          // 1) bottom부터 위로 쌓아올리기 위해 reverse=true가 필요하고
          // 2) 그럼 bottom에 맨첫번째 item이 와야한다 --> descending=true
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return ChatBubbles(
              userName: snapshot.data!.docs[index]['userName'],
              message: snapshot.data!.docs[index]['text'],
              isMe: snapshot.data!.docs[index]['userID'].toString() == user!.uid,
            );
          },
        );
      },
    );
  }
}
