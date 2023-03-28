import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trenifyv1/dataBase/authantication.dart';
import 'package:trenifyv1/provider/country_provider.dart';
import 'package:trenifyv1/settings.dart';

import 'package:trenifyv1/theme_class.dart';
import 'models/country.dart';
import 'result.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late List data=[];
  late List data2=[];


  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/woeid.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }
  Future<void> splitData() async {
    for(int i =0; i<data.length;i++){
      if(data[i]["placeType"]["code"]==12){
        print(data[i]["name"]);
        data2.add(data[i]);
      }
    }
  }


  @override
  void initState() {
    Provider.of<CountryProvider>(context, listen: false).initData().then((e)=>{
      setState(() {
      })
    });
    FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
        'deviceToken': token
      });
    });
    loadJsonData().then((value) => {
      splitData(),
    });
    data.sort((a, b) => a.someProperty.compareTo(b.someProperty));
    data2.sort((a, b) => a.someProperty.compareTo(b.someProperty));
    super.initState();
  }
bool editCheck=false;
  
  @override
  Widget build(BuildContext context) {
    var _counts = context.watch<CountryProvider>().counts;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SettingsPage.isDark
          ? ThemeClass().lightTheme
          : ThemeClass().darkTheme,
      home: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: !SettingsPage.isDark?[Colors.purple, Colors.black]:[Colors.white12, Colors.cyanAccent], stops: const [0.4, 1.0],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            title: const Text('C-Trend'),
            elevation: 1,
            // leading: IconButton(
            //   icon: Icon(
            //     Icons.arrow_back,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (BuildContext context) => MyLogin()));
            //   },
            // ),
            actions: [
              /*
            IconButton(
                icon: const Icon(Icons.lightbulb),
                onPressed: () {

                }),*/
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: !editCheck?Colors.white:Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    editCheck=!editCheck;
                  });

                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage(data: data,)));
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: !SettingsPage.isDark?[Colors.grey.shade500, Colors.black]:[Colors.white60, Colors.cyanAccent], stops: const [0.4, 1.0],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Hero(
                tag: 'logo',
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: _counts.isEmpty?const ListTile(title: Text("Please add a region",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),):GridView.builder(
                          itemCount: _counts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Result(
                                                country: _counts[index].countryName,
                                                countryCode: _counts[index].code,
                                                woeid: _counts[index].woeid.toString(),
                                              )));
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: editCheck?IconButton(icon: Icon(Icons.remove_circle_outline_rounded,size: 35,color: Colors.red,), onPressed: () {
                                        context.read<CountryProvider>().removeFromList(index);
                                      },):
                                      SvgPicture.asset(
                                          'assets/countries/${_counts[index].code.toLowerCase()}.svg',
                                          allowDrawingOutsideViewBox: true,
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                    Text(
                                      _counts[index].countryName,
                                     textAlign: TextAlign.center,
                                     style:  TextStyle(color: !SettingsPage.isDark?Colors.white:Colors.black),
                                    ),
                                  ],
                                ));
                          },
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          padding: const EdgeInsets.all(10),
                          shrinkWrap: true,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          /*gradient: LinearGradient(
                            colors: !SettingsPage.isDark?[Colors.black, Colors.black]:[Colors.cyan, Colors.purple], stops: [0.4, 1.0],
                          ),*/
                        ),
                        child: ElevatedButton(

                          style: ButtonStyle(backgroundColor:!SettingsPage.isDark?MaterialStateProperty.all(Colors.purple):MaterialStateProperty.all(Colors.blue.shade400),
                          ),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Select(
                                      data: data2,
                                    ))),
                          },
                          child: const Text('Add a Region'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class Select extends StatefulWidget {
  List data;
  Select({Key? key, required this.data}) : super(key: key);


  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
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
    var _counts = context.watch<CountryProvider>().counts;
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
                      widget.data[index]["countryCode"].toString().toLowerCase() !=
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
                            _counts.forEach((element) {if(element.countryName==widget.data[index]["name"]){
                              ind=_counts.indexOf(element);
                             check=true;
                        } });
                        if(check){
                          ;
                        }
                        else{
                          context.read<CountryProvider>().addToList(cr);

                      }Navigator.pop(context);
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
