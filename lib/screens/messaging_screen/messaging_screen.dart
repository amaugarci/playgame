// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, curly_braces_in_flow_control_structures, sort_child_properties_last, deprecated_member_use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cardgame/screens/messaging_screen/widgets/chat_bubble.dart';
import 'package:cardgame/utility/firebase_constants.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagingScreen extends StatefulWidget {
  final roomId;
  const MessagingScreen({super.key, required this.roomId});
  @override
  _MessagingScreenState createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final _textMessageController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage(String message) {
    var ref = _firestore.collection(kChatCollection);
    var refUser = _firestore.collection(kUserCollection);
    String uid = auth.currentUser!.uid;

    refUser.doc(uid).get().then((result) {
      ref.doc().set({
        kChatRoomId: widget.roomId,
        kChatStr: message,
        kChatUserId: uid,
        kChatUserName: result.data()![kUserName],
        kChatDate: DateTime.now().toIso8601String().toString(),
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    final textArea = Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 0),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 65,
            ),
            child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              margin: EdgeInsets.all(0.0),
              child: TextField(
                controller: _textMessageController,
                style: kGeneralTextStyle.copyWith(color: kBlack, fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: kLabelTextStyle.copyWith(fontSize: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final sendButton = Align(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: () {
          String message = _textMessageController.text.trim();
          _textMessageController.clear();

          if (message.isEmpty) {
            return;
          }
          sendMessage(message);
        },
        minWidth: 0,
        elevation: 5.0,
        color: kImperialRed,
        child: Icon(
          FontAwesomeIcons.chevronRight,
          size: 25.0,
          color: kWhite,
        ),
        padding: EdgeInsets.all(15.0),
        shape: CircleBorder(),
      ),
    );

    final bottomTextArea = Container(
      color: kImperialRed.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: Stack(
        children: <Widget>[
          // menuButton,
          textArea,
          sendButton,
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Chatting Room"),
      ),
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox.shrink(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection(kChatCollection)
                    //.where(kChatRoomId, isEqualTo: widget.roomId)
                    .orderBy(kChatDate, descending: true)
                    .snapshots(),
                builder: (ctx, snapshot) {
                  if (snapshot.data == null) {
                    print(widget.roomId);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty)
                    return Center(
                      child: Text(
                        'Send your first text in this Room',
                        style: kTitleTextStyle,
                      ),
                    );

                  List<Widget> widgets = [];
                  List<DocumentSnapshot> ds = snapshot.data!.docs;

                  for (var chatData in ds) {
                    if (chatData[kRoomId] == widget.roomId) {
                      widgets.add(ChatBubble(
                        chatData: chatData,
                      ));
                    }
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: widgets.length,
                    itemBuilder: (ctx, index) {
                      return widgets[index];
                    },
                  );
                },
              ),
            ),
            bottomTextArea,
          ],
        ),
      ),
    );
  }
}
