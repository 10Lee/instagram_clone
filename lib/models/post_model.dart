import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String uid;
  final String description;
  final String username;
  final String postId;
  final String postUrl;
  final String profileImage;
  final DateTime datePublished;
  final List likes;

  PostModel({
    required this.uid,
    required this.description,
    required this.username,
    required this.postId,
    required this.postUrl,
    required this.profileImage,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'description': description,
        'username': username,
        'post_id': postId,
        'image_url': postUrl,
        'profile_image': profileImage,
        'publishedAt': datePublished,
        'likes': likes,
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      uid: snapshot['uid'],
      description: snapshot['description'],
      username: snapshot['username'],
      postId: snapshot['post_id'],
      postUrl: snapshot['image_url'],
      profileImage: snapshot['profile_image'],
      datePublished: snapshot['publishedAt'],
      likes: snapshot['likes'],
    );
  }
}
