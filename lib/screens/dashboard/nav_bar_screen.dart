// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, missing_required_param, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cardgame/screens/dashboard/add_room_screen.dart';
import 'package:cardgame/screens/dashboard/widgets/nav_item.dart';
import 'package:cardgame/utility/ui_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardgame/screens/auth/login_screen.dart';

class NavBarScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  _signOut() async {
    await _firebaseAuth.signOut();
  }

  final onPressed;

  NavBarScreen({
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final shrinkSizedBox = Expanded(
      child: SizedBox.shrink(),
    );

    final headingText = Text(
      'Menu',
      style: kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
      textAlign: TextAlign.center,
    );

    final sizedBox10 = SizedBox(height: 10);
    final sizedBox30 = SizedBox(height: 30);

    final navItemClose = NavItem(
      onTap: onPressed,
      title: 'Close Navigation Bar',
      iconData: FontAwesomeIcons.times,
    );

    final navItemAddRoom = NavItem(
      onTap: () {
        final route = MaterialPageRoute(builder: (ctx) => AddRoomScreen());
        Navigator.push(context, route);
      },
      title: 'New Room',
      iconData: FontAwesomeIcons.users,
      //subTitle: 'Add a new room. And, invite your friends.',
    );

    final navItemReportBug = NavItem(
      onTap: () async {
        await _signOut();
        if (_firebaseAuth.currentUser == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
      title: 'Sign Out',
      iconData: FontAwesomeIcons.signOut,
      //subTitle: 'File an issue on the Github Repo',
    );

    return Container(
      color: kSteelBlue.withOpacity(0.10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                sizedBox10,
                headingText,
                sizedBox30,
                navItemClose,
                sizedBox30,
                navItemAddRoom,
                sizedBox30,
                navItemReportBug,
              ],
            ),
          ),
          shrinkSizedBox,
        ],
      ),
    );
  }
}
