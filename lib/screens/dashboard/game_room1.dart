// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables

import 'package:cardgame/utility/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:cardgame/screens/messaging_screen/messaging_screen.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:cardgame/screens/home_screen.dart';

class GameRoomScreen extends StatefulWidget {
  final roomData;
  const GameRoomScreen({Key? key, required this.roomData}) : super(key: key);

  @override
  _GameRoomScreenState createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  final GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  late String title;

  @override
  void initState() {
    title = "Game Room";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderDrawer(
            appBar: SliderAppBar(
                appBarColor: Colors.white,
                title: Text(title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700))),
            key: _key,
            sliderOpenSize: MediaQuery.of(context).size.width * 0.9,
            slider: MessagingScreen(
                // onItemClick: (title) {
                //   _key.currentState!.closeSlider();
                //   setState(() {
                //     this.title = title;
                //   });
                // },
                roomId: widget.roomData),
            child: HomeScreen()),
      ),
    );
  }
}
