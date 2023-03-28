import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trenifyv1/home_page.dart';
import 'package:trenifyv1/provider/country_provider.dart';
import 'dataBase/authantication.dart';
import 'login.dart';
import 'register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  Future<String?> getToken() async {
    final fcmToken = FirebaseMessaging.instance.getToken();
    final String? token= await fcmToken;
    return token;
  }
  void initState() {

    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
          'status': 1
        });
        getToken().then((value) =>  FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
          'deviceToken': value
        }));
      }
    });
  }
  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  FirebaseAuth.instance.currentUser == null ?const MyLogin():MyHome(),
        routes: {
          'register': (context) => const MyRegister(),
          'login': (context) => const MyLogin(),
        },
      ),
    );
  }
}