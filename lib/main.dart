// ignore_for_file: use_key_in_widget_constructors, unused_import, prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package::cardgame/screens/auth/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:cardgame/screens/splash_screen.dart';
import 'package:cardgame/screens/dashboard/add_room_screen.dart';
import 'package:cardgame/screens/dashboard/dashboard_screen.dart';
import 'package:stream_chat/stream_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO);

  await client.connectUser(
    User(
      id: 'cool-shadow-7',
      name: 'Cool Shadow',
      image:
          'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
    ),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo''',
  );

  final channel = client.channel('messaging', id: 'godevs');

  await channel.watch();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD-4MdDJc1TXSpfgEVFiAXGTWOA84AY05g",
        appId: "1:1082828457333:web:e1189f08b689e065183f3c",
        messagingSenderId: "phoenixdev0211@gmail.com",
        projectId: "playgame1-5a5f9",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) => SplashScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/add_room': (context) => AddRoomScreen(),
      },
      initialRoute: '/home',
      //initialRoute: '/dashboard',
    );
  }
}
