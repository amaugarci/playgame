// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_const_declarations, avoid_returning_null_for_void, must_be_immutable
import 'package:flutter/material.dart';
import 'package:cardgame/utility/firebase_constants.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardgame/screens/dashboard/game_ready.dart';

class RoomItemWidget extends StatelessWidget {
  RoomItemWidget({
    this.roomData,
    this.context,
    this.visibility,
  });

  final context;
  final roomData;
  final visibility;
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<dynamic> joinMembers = [];

  void enterRoom(var context) async {
    var ref = firestore.collection(kRoomCollection);
    String uid = auth.currentUser!.uid;
    String username = '';
    firestore.collection(kUserCollection).doc(uid).get().then((val) {
      username = val.data()![kUserName];
    });

    await ref
        .where(kRoomId, isEqualTo: roomData[kRoomId])
        .get()
        .then((event) async {
      for (var doc in event.docs) {
        for (var member in doc.data()[kJoinMembers]) {
          if (member['uid'] != uid) {
            joinMembers.add(member);
          }
        }
        joinMembers.add({'uid': uid, 'name': username});
        await ref.doc(roomData[kRoomId]).set({
          kJoinMembers: joinMembers,
          kRoomId: doc.data()[kRoomId],
          kRoomName: doc.data()[kRoomName]
        });
      }
    });

    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => GameReadyScreen(roomId: roomData[kRoomId]),
        ))
        .then((_) async => {
              joinMembers = [],
              await ref
                  .where(kRoomId, isEqualTo: roomData[kRoomId])
                  .get()
                  .then((event) async {
                for (var doc in event.docs) {
                  for (var member in doc.data()[kJoinMembers]) {
                    if (member['uid'] != uid) {
                      joinMembers.add(member);
                    }
                  }
                  await ref.doc(roomData[kRoomId]).set({
                    kJoinMembers: joinMembers,
                    kRoomId: doc.data()[kRoomId],
                    kRoomName: doc.data()[kRoomName]
                  });
                }
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: kImperialRed, width: 1),
    );

    final cardMargin = const EdgeInsets.only(
      bottom: 5,
      top: 10,
    );

    final contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    );
    final roomNameText = Text(
      roomData[kRoomName],
      style: kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
    );

    final roomIdText = Text(
      'Room ID: ${roomData[kRoomId]}',
      style: kGeneralTextStyle.copyWith(fontSize: 15, color: kBlack),
    );

    return Visibility(
      visible: true,
      // visible: visibility,
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: shape,
        margin: cardMargin,
        child: InkWell(
          onTap: () => enterRoom(context),
          splashColor: kImperialRed.withAlpha(100),
          child: Padding(
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                roomNameText,
                SizedBox(height: 20),
                roomIdText,
                //createdAtText,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
