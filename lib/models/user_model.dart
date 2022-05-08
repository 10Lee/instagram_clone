import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String bio;
  final String email;
  final String photoUrl;
  final String uid;
  final List followers;
  final List following;

  UserModel({
    required this.username,
    required this.bio,
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'photo': photoUrl,
        'following': following,
        'followers': followers,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      username: snapshot['username'],
      bio: snapshot['bio'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      uid: snapshot['uid'],
      followers: snapshot['followers'],
      following: snapshot['following'],
    );
  }
}
