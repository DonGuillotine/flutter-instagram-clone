import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post

  Future<String> uploadPost({
    required String description,
    required Uint8List file,
    required String uid,
    required String username,
    required profileImage,
  }) async {
    String res = 'An Error Occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadToStorage('posts', file, true);
      // This creates a new uid every time
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );

      // Submit our post to fire store create a collection 'posts'
      // Then a postId
      // Then convert our Post object to Json
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  // If the uid is present in the likes List remove the uid or uid s
  // else add the uid to the likes List
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<String> commentOnPost({
    required String comment,
    required String uid,
    required String postId,
    required String username,
    required profileImage,
  }) async {
    String res = 'An Error Occurred';
    try {
      // create a new commentId
      // access the collection 'posts', then the doc 'postId' then create a sub collection 'comments' with doc of commentId

      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profileImage': profileImage,
          'username': username,
          'uid': uid,
          'comment': comment,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        res = 'Please Enter Comment';
      }
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> follow(String uid, String otherUsersID) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      // IF the followers list in firebase has other my ID remove it if we wish to unfollow
      if (following.contains(otherUsersID)) {
        await _firestore.collection('users').doc(otherUsersID).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        // IF the following list in firebase has other users ID remove it if we wish to unfollow
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([otherUsersID])
        });
      } else {
        // IF the followers list in firebase doesn't have my ID add it to unfollow
        await _firestore.collection('users').doc(otherUsersID).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        // IF the following list in firebase doesn't have other users ID remove it if they wish to follow
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([otherUsersID])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
