import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:instagram_with_provider/utils/colors.dart';
import 'package:instagram_with_provider/utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};

  int postLength = 0;
  int following = 0;
  int followers = 0;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
      var fetchUser = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = fetchUser.data()!;
      following = fetchUser.data()!['following'].length;
      followers = fetchUser.data()!['followers'].length;

      var fetchPost = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLength = fetchPost.docs.length;

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackground,
        centerTitle: false,
        title: Text(userData['username'].toString()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 55,
                onBackgroundImageError: (exception, stackTrace) =>
                    const CircularProgressIndicator(),
                backgroundImage:
                    NetworkImage(userData['profile_url'].toString()),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    postLength.toString(),
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Posts",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    following.toString(),
                                    style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Following",
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    followers.toString(),
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Followers",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        margin: const EdgeInsets.all(20.0),
                        height: 40.0,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: const Center(child: Text("Edit Profile")),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            userData['username'].toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          Text(userData['bio'].toString()),
        ],
      ),
    );
  }
}
