import 'package:cloud_firestore/cloud_firestore.dart';

import '../dataBase/authantication.dart';
import '/models/country.dart';
import 'package:flutter/material.dart';

class CountryProvider with ChangeNotifier {
  List<Countries> initialData =  [];
  final List<Countries> _counts = [];
   Countries _favorite = Countries(countryName: "null", woeid: 0, code: "null");
  Countries get favorite => _favorite;
  List<Countries> get counts => _counts;
  List ls=[];
  List<String>? s=[];
  Future<void> initData() async{
    _counts.clear();
    ls.clear();
     await FirebaseFirestore.instance.collection("lists").doc(Authentication().userUID).get().then((value){
       print(value.data().toString());
       s=value.data()?["favorite"].toString().split("*");
       if(s!=[]){
         _favorite.code=s![0].toString();
       }else{
         FirebaseFirestore.instance.collection("lists").doc(Authentication().userUID).update({"favorites":""});
       }
      value.data()?["list"].forEach(
              (data){
                if(!ls.contains(data.toString())){
                  ls.add(data.toString());
                  List dataList=data.toString().split("*");
                  _counts.add(Countries(countryName: dataList[1], woeid: int.parse(dataList[2]), code: dataList[0]));
                }
          }
      );
    });
  }
  void addToFavorite(Countries country) {
    _favorite=country;
    String s=country.code+"*"+country.countryName+"*"+country.woeid.toString();
    FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
      'favorite':s
    });
    notifyListeners();
  }
  void removeFavorite(Countries country) {
    FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
        'favorite':""
    });

    _favorite=Countries(woeid: 0, code: "", countryName: "");
    notifyListeners();
  }
  void addToList(Countries country) {
    _counts.add(country);
    String s=country.code+"*"+country.countryName+"*"+country.woeid.toString();
    if(!ls.contains(s)){
      ls.add(s);
    }
    FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
      'list':ls
    });
    notifyListeners();
  }

  void removeFromList(int index) {
    _counts.removeAt(index);
    ls.removeAt(index);
    FirebaseFirestore.instance.collection('lists').doc(Authentication().userUID).update({
      'list': ls
    });
    notifyListeners();
  }
}
