// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables

//import 'package:cardgame/utility/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:cardgame/screens/messaging_screen/messaging_screen.dart';
//import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
//import 'package:cardgame/screens/home_screen.dart';

class GameRoomScreen extends StatefulWidget {
  final roomId;
  const GameRoomScreen({Key? key, required this.roomId}) : super(key: key);

  @override
  _GameRoomScreenState createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  late String title;

  @override
  void initState() {
    title = "Game Room";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
                icon: Icon(Icons.keyboard_double_arrow_right),
                onPressed: () {
                  Navigator.pop(context);
                }),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.notifications),
            ),
          ],
        ),
        body: const Center(
          child: Text('Enjoy!'),
        ),
        drawer: MessagingScreen(roomId: widget.roomId));
  }
}
