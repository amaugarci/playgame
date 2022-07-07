// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:cardgame/component/button.dart';
import 'package:cardgame/screens/dashboard/game_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardgame/utility/firebase_constants.dart';

class GameReadyScreen extends StatefulWidget {
  final roomId;
  const GameReadyScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _GameReadyScreenState createState() => _GameReadyScreenState();
}

class _GameReadyScreenState extends State<GameReadyScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> joinMembers = [];

  @override
  void initState() {
    super.initState();
    _firestore.collection(kRoomCollection).doc(widget.roomId).get().then((val) {
      for (var m in val.data()![kJoinMembers]) {
        joinMembers.add(m['name']);
        setState(() {});
      }
    });
  }

  void gameRoom(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => GameRoomScreen(roomId: widget.roomId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    //List<String> joins = widget.roomData[kJoinMembers].cast<String>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Ready Room"),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i in joinMembers) Text(i.toString()),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed:
                    (joinMembers.length > 3) ? () => gameRoom(context) : null,
                child: Text("Start Game")),
          ],
        ),
      ),
    );
  }
}
