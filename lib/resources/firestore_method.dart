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
}
