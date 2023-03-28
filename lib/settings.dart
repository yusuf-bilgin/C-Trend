import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:trenifyv1/forgot_password.dart';
import 'package:trenifyv1/login.dart';
import 'package:trenifyv1/provider/country_provider.dart';

import 'dataBase/authantication.dart';
import 'home_page.dart';
import 'models/country.dart';

class SettingsPage extends StatefulWidget {
  List data;
  SettingsPage({Key? key,required this.data}) : super(key: key);
  static bool isDark = true;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

ThemeData lightTheme =
    ThemeData(brightness: Brightness.light, primaryColor: Colors.blue);

ThemeData darkTheme =
    ThemeData(brightness: Brightness.dark, primaryColor: Colors.black);

bool _volumeOn = true;

void logout() async {
  FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
    'status': 0
  });
  await FirebaseAuth.instance.signOut();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> syncInterval()async{
    await FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).get().then((value){
      setState(() {
        interval=value.data()?["interval"];
      });
  });
  }

  int interval=1;
  int check=1;
  @override
  void initState() {
    syncInterval();
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: SettingsPage.isDark ? lightTheme : darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 1,
            leading: IconButton(
              onPressed: () {

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHome()),
                    (route) => false).then((value) => {
                setState(() {

                })
                });
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                const Text(
                  "Settings",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Account",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(
                  height: 15,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                buildAccountOptionRow(context, "Change password"),
                buildAccountOptionRow(context, "Log Out"),

                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: const [
                    Icon(
                      Icons.notifications_active,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Notifications",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Divider(
                  height: 15,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Notification Country:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Select2(data: widget.data)));
                          },
                          child: Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()=="" ||Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()== null?

                          Icon(Icons.explore_outlined,
                            color: Colors.grey,):Row(
                              children: [
                                SvgPicture.asset(
                   'assets/countries/${Provider.of<CountryProvider>(context).favorite.code.toLowerCase()}.svg',
            allowDrawingOutsideViewBox: true,
            width: 40,
            height: 40,
          ),
                              IconButton(onPressed: (){setState(() {

                                check=0;
                              });Provider.of<CountryProvider>(context,listen: false).removeFavorite(Provider.of<CountryProvider>(context,listen: false).favorite);}
                                  , icon: Icon(Icons.delete,color: Colors.red,))],
                            ),

                      ),
                    ],
                  ),
                ),

            Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()!="" &&Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()!= null?
            Slider(
                  divisions: 6,
                  value: interval.toDouble(),
                  min: 0.6,
                  max: 24,
                  activeColor: Colors.red,
                  inactiveColor: Colors.grey,
                  label: "$interval",
                  onChangeEnd: (double newValue) {
                    setState(() {
                      FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
                        'interval':interval,
                      });
                    });
                  },
                  onChanged: (double newValue) {
                    setState(() {
                      interval = newValue.round();
                    });
                  },
                ):Text(""),Text(Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()!="" &&Provider.of<CountryProvider>(context).favorite.code.toString().toLowerCase()!= null?"Notification Interval (Every $interval hour)":"",textAlign: TextAlign.center,),
                const SizedBox(
                  height: 40,
                ),
                /*Row(
                  children: [
                    const Icon(
                      Icons.volume_up_outlined,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Sound Mode",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                        value: _volumeOn,
                        onChanged: (state) {
                          setState(() {
                            _volumeOn = state;
                          });
                        }),
                  ],
                ),*/
                const Divider(
                  height: 15,
                  thickness: 2,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.light_mode,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "Theme",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                        value: SettingsPage.isDark,
                        onChanged: (state) {
                          setState(() {
                            SettingsPage.isDark = state;
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title == 'Log Out'
                        ? "Do You Want to\n Log Out?"
                        : "Do You Want to Change\nYour Password?",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                SizedBox(width: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      fixedSize: const Size.fromWidth(100),
                      padding: const EdgeInsets.all(10)),
                  child: const Text("YES"),
                  onPressed: () {
                    if (title == "Log Out") {
                      setState(() {
                        logout();
                      });

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MyLogin()),
                          (route) => false);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()),
                      );
                    }
                  },
                ),
                SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      fixedSize: const Size.fromWidth(100),
                      padding: const EdgeInsets.all(10)),
                  child: const Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 5),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}


class Select2 extends StatefulWidget {
  List data;
  Select2({Key? key, required this.data}) : super(key: key);


  @override
  State<Select2> createState() => _Select2State();
}

class _Select2State extends State<Select2> {
  List data2=[];

  void filterList (String word){
    List? result=[];
    if(word.isEmpty){
      result=data2;
    }else{
      result=data2.where((element) => element["name"].toLowerCase().contains(word.toLowerCase())).toList();
    }
    setState(() {
      widget.data=result!;
    });
  }
  @override
  void initState() {
    data2=widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: !SettingsPage.isDark?[Colors.purple, Colors.black]:[Colors.white12, Colors.cyanAccent], stops: const [0.4, 1.0],
            ),
          ),
        ),
        title: const Text("Select Region"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value)=>filterList(value),
              decoration: const InputDecoration(
                  labelText: ' Search',
                  suffixIcon: Icon(Icons.search)
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data == null ? 0 : widget.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      trailing:
                      widget.data[index]["name"].toString().toLowerCase() !=
                          "null"
                          ? SizedBox(

                        width: 30,
                        height: 30,
                        child: SvgPicture.asset(
                          'assets/countries/${widget.data[index]["countryCode"].toString().toLowerCase()}.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                      )
                          : null,
                      title: Text(
                        widget.data[index]["name"],
                      ),
                      onTap: () {
                        bool check=false;
                        int ind=0;
                        Countries cr=Countries(
                            countryName: widget.data[index]["name"],
                            code: widget.data[index]["countryCode"],
                            woeid: widget.data[index]["woeid"]);
                           Provider.of<CountryProvider>(context,listen: false).addToFavorite(cr);
                        Navigator.pop(context);
                      },
                    ),
                    const Divider(thickness: 1,color: Colors.black,)
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
