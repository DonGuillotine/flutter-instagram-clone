import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  // Instantiating FirebaseStorage and FirebaseAuth Class

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Adding Image to FirebaseStorage
  // These arguments will be passed in auth_methods
  // bool isPost will be used later for actual Posts

  Future<String> uploadToStorage(
      String childName, Uint8List file, bool isPost) async {
    // .ref() is a pointer to the file in our storage, could be a file that exists or doesn't exist
    // .child() can be a folder that does or doesn't exist, if latter Firebase creates a new one
    // The next child is the uid gotten from FirebaseAuth for a particular user
    // The property 'uid' can't be unconditionally accessed because the receiver can be 'null'. Added the ! operator

    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    // One user can make multiple posts soo
    // If we want to post create another child inside the user id that is (child(_auth.currentUser!.uid)) which will contain the post id
    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // Upload the File

    UploadTask uploadTask = ref.putData(file);

    // Await the Upload Task

    TaskSnapshot snap = await uploadTask;

    // .ref is a different property in another file, don't bother
    // This will fetch a download Url for the Image

    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
