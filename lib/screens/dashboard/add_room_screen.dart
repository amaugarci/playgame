// ignore_for_file: depend_on_referenced_packages, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last, unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardgame/utility/firebase_constants.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:cardgame/widgets/card_text_field.dart';

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _roomNameController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String username = '';

  @override
  void initState() {
    super.initState();
    String uid = auth.currentUser!.uid;
    _firestore.collection(kUserCollection).doc(uid).get().then((val) {
      username = val.data()![kUserName];
    });
  }

  void createNewRoom() async {
    String inputRoomName = _roomNameController.text.trim();
    _roomNameController.clear();

    assert(inputRoomName != null && inputRoomName.isNotEmpty);

    var ref = _firestore.collection(kRoomCollection);
    String uid = auth.currentUser!.uid;
    String roomName = inputRoomName;
    List<dynamic> joinMember = [];
    // dynamic member = {'uid': uid, 'name': username};
    // joinMember.add(member);
    final roomid = UniqueKey().hashCode.toString();
    await ref
        .doc(roomid)
        .set({kRoomId: roomid, kRoomName: roomName, kJoinMembers: joinMember});
    // close the screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var containerPadding = const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    );

    var sizedBox20 = SizedBox(
      height: 20,
    );

    var headingText = Text(
      'Add a new Room',
      style: kHeadingTextStyle,
      textAlign: TextAlign.center,
    );

    var labelText = Text(
      '',
      style: kLightLabelTextStyle,
      textAlign: TextAlign.center,
    );

    var textFieldRoomName = CardTextField(
        controller: _roomNameController,
        labelText: 'Room Name',
        iconData: FontAwesomeIcons.napster);

    // ignore: deprecated_member_use
    var createRoomButton = ElevatedButton(
      child: Text(
        'Create Room',
        style: kGeneralTextStyle,
      ),
      onPressed: createNewRoom,
    );

    return Scaffold(
      backgroundColor: kSteelBlue,
      appBar: AppBar(
        backgroundColor: kSteelBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          padding: containerPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              headingText,
              sizedBox20,
              labelText,
              sizedBox20,
              textFieldRoomName,
              sizedBox20,
              sizedBox20,
              sizedBox20,
              createRoomButton,
            ],
          ),
        ),
      ),
    );
  }
}
