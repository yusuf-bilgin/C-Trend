import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final _fireAuth = FirebaseAuth.instance;

  String get userUID => _fireAuth.currentUser!.uid;

  // String? get mail => _fireAuth.currentUser!.email;
  Future<String> logIn(String email, String password) async {
    try {
      UserCredential userCreds=await _fireAuth.signInWithEmailAndPassword(
          email: email, password: password);

        FirebaseFirestore.instance.collection('lists').doc(userUID).update({
         'status': 1
       });
      return 'true';
    } catch (e) {
      return e.toString() ==
              "[firebase_auth/unknown] Given String is empty or null"
          ? "Given String is empty.\nFill The Blanks!"
          : (e.toString() ==
                  "[firebase_auth/invalid-email] The email address is badly formatted."
              ? "e-mail address is formatted badly.\nTry it again!"
              : (e.toString() ==
                      "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."
                  ? "The password is invalid or the user does not have a password!"
                  : (e.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."
                      ? "There is no user record corresponding to this identifier.\n\nThe user may have been deleted!"
                      : (e.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later."
                          ? "We have blocked all requests from this device due to unusual activity.\n\nTry again later!!"
                          : "Something went wrong.\n\nTry again!!"))));
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      UserCredential userCreds= await _fireAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'true';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Weak password, try stronger one';
      } else if (e.code == 'email-already-in-use') {
        return 'The e-mail has been used before';
      } else {
        return e.message!;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> forgotPassword(String email) async {
    try {
      await _fireAuth.sendPasswordResetEmail(email: email);
      return 'true';
    } catch (e) {
      return e.toString() ==
              "[firebase_auth/unknown] Given String is empty or null"
          ? "Given String is empty.\nFill The Blanks!"
          : (e.toString() ==
                  "[firebase_auth/invalid-email] The email address is badly formatted."
              ? "e-mail address is formatted badly.\nTry it again!"
              : (e.toString() ==
                      "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."
                  ? "The password is invalid or the user does not have a password!"
                  : (e.toString() ==
                          "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted."
                      ? "There is no user record corresponding to this identifier.\n\nThe user may have been deleted!"
                      : (e.toString() ==
                              "[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later."
                          ? "We have blocked all requests from this device due to unusual activity.\n\nTry again later!!"
                          : "Something went wrong.\n\nTry again!!"))));
    }
  }

  Future<String> logOut() async {
    try {
      await _fireAuth.signOut();
      return 'true';
    } catch (e) {
      return e.toString();
    }
  }
}
