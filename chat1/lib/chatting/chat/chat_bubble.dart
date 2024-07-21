import 'package:flutter/material.dart';

import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';


class ChatBubbles extends StatelessWidget {
  const ChatBubbles({required this.userName, required this.message, required this.isMe, super.key,});

  final String userName;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        // Container(
        //   width: 145,
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        //   margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        //   decoration: BoxDecoration(
        //     color: isMe ? Colors.grey[300] : Colors.blue,
        //     borderRadius: BorderRadius.only(
        //       topRight: Radius.circular(12),
        //       topLeft: Radius.circular(12),
        //       bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
        //       bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
        //     ),
        //   ),
        //   child: Text(message, style: TextStyle(color: isMe ? Colors.black : Colors.white),),
        // ),
        if(isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,5,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(top: 20),
              backGroundColor: Colors.blue,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    Text(message, style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if(!isMe)
          Padding(
            padding: const EdgeInsets.fromLTRB(5,0,0,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
              backGroundColor: Color(0xffE7E7ED),
              margin: EdgeInsets.only(top: 20),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                    Text(message, style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),

      ],
    );
  }
}
