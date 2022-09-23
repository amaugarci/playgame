// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, dead_code, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_chat/stream_chat.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    required this.chatData,
  });

  final FirebaseAuth auth = FirebaseAuth.instance;
  Message chatData;

  final borderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    String uid = auth.currentUser!.uid;
    var chatContents = chatData;
    bool isMe = (uid == chatContents.extraData['senderId']);
    final decoration = BoxDecoration(
      color: isMe ? kSteelBlue : kSteelBlue.withOpacity(0.08),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(isMe ? 0.0 : borderRadius),
        bottomRight: Radius.circular(isMe ? 0.0 : borderRadius),
        topLeft: Radius.circular(isMe ? borderRadius : 0.0),
        bottomLeft: Radius.circular(isMe ? borderRadius : 0.0),
      ),
    );

    final textContent = Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isMe
              ? DateFormat('hh:mm a').format(chatContents.createdAt)
              : '${chatContents.extraData['senderName']}   ${DateFormat('hh:mm a').format(chatContents.createdAt)}',
          style: kLightestTextStyle.copyWith(
            color: isMe ? kWhite : kBlack,
          ),
        ),
        SizedBox(height: 10),
        Text(
          chatContents.text!,
          style: kLabelTextStyle.copyWith(
            color: isMe ? kWhite : kBlack,
          ),
        ),
      ],
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: isMe ? 100.0 : 10.0,
          right: isMe ? 10.0 : 100.0,
        ),
        decoration: decoration,
        child: textContent,
      ),
    );
  }
}
