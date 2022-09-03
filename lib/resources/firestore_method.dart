import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_with_provider/resources/storage_method.dart';
import '../models/post_model.dart';

class FirestoreMethod {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String uid,
    Uint8List file,
    String description,
    String profileImage,
    String username,
  ) async {
    String res = 'Entering try catch';

    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      PostModel post = PostModel(
        uid: uid,
        description: description,
        username: username,
        postId: postId,
        postUrl: postUrl,
        profileImage: profileImage,
        datePublished: DateTime.now(),
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
      print(e.toString());
    }
    return res;
  }

  Future<void> likePost(String uid, String postId, List likes) async {
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
      print(e.toString());
    }
  }

  Future<void> postComments(String postId, String text, String uid, String name,
      String profileImage) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'profile_image': profileImage,
            'name': name,
            'uid': uid,
            'text': text,
            'commentId': commentId,
            'publishedAt': DateTime.now(),
          },
        );
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Follow functionality
  Future<void> followUser(String originID, String targetID) async {
    try {
      var snap = await _firestore.collection('users').doc(originID).get();

      List followingList = snap.data()!['following'];

      // If there is uid listed in firestore, remove it
      if (followingList.contains(targetID)) {
        await _firestore.collection('users').doc(targetID).update({
          'followers': FieldValue.arrayRemove([originID])
        });
        await _firestore.collection('users').doc(originID).update({
          'following': FieldValue.arrayRemove([targetID])
        });
      } else {
        // if the comparable uid is not listed add it
        await _firestore.collection('users').doc(targetID).update({
          'followers': FieldValue.arrayUnion([originID])
        });
        await _firestore.collection('users').doc(originID).update({
          'following': FieldValue.arrayUnion([targetID])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
