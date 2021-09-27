import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signIn(String _email, String _password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: _email, password: _password);
    return user.user;
  }

  Future<UserCredential> createPerson({
    required String email,
    required String password,
  }) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return user;
  }

  Future<void> setUserID({
    required String userID,
    required String userName,
    required String email,
    required String password,
    required String number,
    required String identityNo,
    required String address,
    required String birthDay,
    required String gender,
  }) async {
    await _firebaseFirestore.collection("Person").doc(userID).set({
      "userName": userName,
      "email": email,
      "number": number,
      "identityNo": identityNo,
      "address": address,
      "birthDay": birthDay,
      "gender": gender,
      "coin1": 0,
      "coin2": 0,
      "coin3": 0,
      "coin4": 0,
      "role": "user",
      "userID": userID,
      "userBank": "",
      "isHaveBank": false,
      "wantedBuyCoin": -1,
      "wantedSellCoin": -1,
      "requestType": -1,
      "isWantToBuy": false,
    });
  }

  signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future passwordReset(String _email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: _email);
  }
}
