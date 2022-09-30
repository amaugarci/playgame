// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cardgame/utility/firebase_constants.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:cardgame/widgets/not_found.dart';
import 'package:cardgame/screens/dashboard/widgets/room_item_widget.dart';

class ForegroundScreen extends StatefulWidget {
  final navBarOnPressed;

  ForegroundScreen({
    @required this.navBarOnPressed,
  });

  @override
  _ForegroundScreenState createState() => _ForegroundScreenState();
}

class _ForegroundScreenState extends State<ForegroundScreen> {
  final CollectionReference _rooms =
      FirebaseFirestore.instance.collection(kRoomCollection);

  bool showProgress = false;

  void showProgressIndicator(bool show) {
    setState(() {
      showProgress = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxHeight = SizedBox(
      height: 10.0,
    );

    final headingText = Text(
      'Card Game',
      style: kHeadingTextStyle.copyWith(
        fontSize: 40,
      ),
      textAlign: TextAlign.center,
    );

    final titleText = Text(
      'Join a room to continue',
      style: kLightLabelTextStyle,
      textAlign: TextAlign.center,
    );

    final navButton = Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(
          FontAwesomeIcons.bars,
          color: kWhite,
        ),
        onPressed: widget.navBarOnPressed,
      ),
    );

    final boxDecoration = BoxDecoration(
      color: kWhite,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    );

    final streamBuilder = StreamBuilder<QuerySnapshot>(
      stream: _rooms.snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          for (var m in room[kJoinMembers]) {
            joinMembers.add(m['name']);
          }
          var memberCount = joinMembers.length;

          bool flag = false;
          if (memberCount < 4) {
            flag = true;
          }
          widgets.add(RoomItemWidget(
            context: context,
            roomData: room,
            visibility: flag,
          ));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
          itemCount: widgets.length,
          itemBuilder: (ctx, index) {
            return widgets[index];
          },
        );
      },
    );

    final circularProgressIndicator = Center(
      child: CircularProgressIndicator(),
    );

    final listOfRooms = Expanded(
      child: Container(
        decoration: boxDecoration,
        child: showProgress ? circularProgressIndicator : streamBuilder,
      ),
    );

    final mainCol = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        headingText,
        sizedBoxHeight,
        titleText,
        sizedBoxHeight,
        listOfRooms,
      ],
    );

    final foregroundScreen = Container(
      color: Color.fromARGB(255, 107, 96, 232),
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            mainCol,
            navButton,
          ],
        ),
      ),
    );

    return foregroundScreen;
  }
}
