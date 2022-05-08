import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_with_provider/models/user_model.dart';
import 'package:instagram_with_provider/resources/storage_method.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'try-catch is not working';

    try {
      if (username.isNotEmpty ||
          email.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        // if there is none of the param is empty then register user in firebaseAuth
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print("USER UID : ${cred.user!.uid}");

        String photo = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        UserModel userModel = UserModel(
          username: username,
          bio: bio,
          email: email,
          photoUrl: photo,
          uid: cred.user!.uid,
          followers: [],
          following: [],
        );

        // Save the user username, bio and image path to firestore with 'cred' UID
        _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userModel.toJson());

        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> logInUser(
    String email,
    String password,
  ) async {
    String res = 'try catch is not working';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
