import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  var _userEnterMessage  = "";
  final _controller = TextEditingController();

  // 전송 버튼 눌렀을 때 
  void _sendNewMessage() async {
    FocusManager.instance.primaryFocus!.unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();

    FirebaseFirestore.instance.collection('chat').add(
      {
        'userName': userData.data()!['userName'],
        'text': _userEnterMessage,
        'time': Timestamp.now(),    // firestore에서 제공되는 기능
        'userID': user!.uid,
      },
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "Send a message...",
              ),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send,),
            color: Colors.blue,
            disabledColor: Colors.grey,
            onPressed: _userEnterMessage.trim().isEmpty
                ? null    // IconButton을 disable 시킴
                : _sendNewMessage,
          ),
        ],
      ),
    );
  }
}
