// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables
import 'package:cardgame/widgets/not_found.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> joinMembers = [];
  final CollectionReference _rooms =
      FirebaseFirestore.instance.collection(kRoomCollection);

  @override
  void initState() {
    super.initState();
    // _firestore.collection(kRoomCollection).doc(widget.roomId).get().then((val) {
    //   for (var m in val.data()![kJoinMembers]) {
    //     joinMembers.add(m['name']);
    //     setState(() {});
    //   }
    // });
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
            Expanded(
                child: StreamBuilder(
                    stream: _rooms.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) return NotFoundWidget();

                      List<Widget> widgets = [];
                      List<DocumentSnapshot> ds = snapshot.data!.docs;
                      for (var room in ds) {
                        List<String> joinMembers = [];
                        if (room[kRoomId] == widget.roomId) {
                          for (var m in room[kJoinMembers]) {
                            joinMembers.add(m['name']);
                          }
                        }
                      }
                      for (var i in joinMembers) {
                        widgets.add(Text(i.toString()));
                      }
                      return ListView.builder(
                        itemCount: widgets.length,
                        itemBuilder: (ctx, index) {
                          return widgets[index];
                        },
                      );
                    })),
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
