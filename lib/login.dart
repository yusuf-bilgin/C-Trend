import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trenifyv1/home_page.dart';
import 'package:just_audio/just_audio.dart';

import 'dataBase/authantication.dart';
import 'forgot_password.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  late AudioPlayer player;
  int ind=1;
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  final myController = TextEditingController();
  final myControllerPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/hashtag3.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: const EdgeInsets.only(left: 35, top: 110),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(onPressed: (){
                      setState(() {
                      if(ind==1){
                          ind=0;
                      }else{
                          ind=1;
                      }
                        player.setVolume(ind.toDouble());
                      });
                    }, child: Container(margin: const EdgeInsets.only(left: 35, right: 35),child: Text(ind!=1?"🔇":"🔉",style: const TextStyle(fontSize: 40),))),
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: myController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: myControllerPw,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    const AssetImage('assets/bird.png'),
                                child: TextButton(
                                  onPressed: () async {
                                    await player.setAsset('assets/cikcik.mp3');
                                    player.play();
                                    var signing = await Authentication().logIn(
                                        myController.text, myControllerPw.text);
                                    if (signing == 'true') {
                                      final snapShot = await FirebaseFirestore.instance
                                          .collection("lists")
                                          .doc(Authentication().userUID) // varuId in your case
                                          .get();

                                      if (snapShot == null || !snapShot.exists) {
                                        FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).set({
                                          'interval':1,
                                          'favorite':"",
                                          'list': [],
                                          'status': 1
                                        });
                                      }
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const MyHome();
                                          },
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text(signing,textAlign: TextAlign.center,),
                                          );
                                        },
                                      );
                                    }
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const MyHome()));
                                  },
                                  child: const SizedBox(
                                    width: 0,
                                    height: 0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'register');
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                  style: const ButtonStyle(),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPassword()));
                                  },
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
