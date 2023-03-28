import 'package:cloud_firestore/cloud_firestore.dart';

import 'authantication.dart';

class FireStore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser(
      {required String name,
      required String email,
      required String password}) async {
    String uids = Authentication().userUID;
    _firebaseFirestore.collection('users').doc(uids).set(
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }
}
