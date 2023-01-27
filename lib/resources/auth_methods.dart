import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
// Firebase auth has a user class and we also have a user class in models/user.dart
// So 'as model' is used to differentiate them
import 'package:instagram_flutter/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// A function to get User details
  Future<model.User> getUserDetails() async {
    // First find out the current user
    User currentUser = _auth.currentUser!;
    // Access the users collection then the users uid
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    // Return the fromSnap function in models/user.dart
    return model.User.fromSnap(snap);
  }

// User Sign Up Function
// All Calls to firebase are going to be asynchronous so we use the Future return type
// So the function would be async, and the return type will be future

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "An Error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // Register the User if Conditions are met
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // The property 'uid' can't be unconditionally accessed because the receiver can be 'null'.
        // So '!' is used before '.'
        // 'cred' gets the uid

        print(cred.user!.uid);

        // Add the Profile Picture to Storage @storage_methods.dart

        String photoUrl = await StorageMethods()
            .uploadToStorage('profilePictures', file, false);

        // Add the User to the database
        // model is an import prefix to avoid clashes
        // model.User class is located in models/user.dart
        // Create a new collection->users, then a uid and set our values
        // the values of model.User user is converted to a json object
        // Passwords are not saved to the database

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          following: [],
          followers: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // To Log in the user
  Future<String> logInUser({
    required String email,
    required String password,
  }) async {
    // It is unlikely that this res will run
    String res = 'An error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Enter all fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
