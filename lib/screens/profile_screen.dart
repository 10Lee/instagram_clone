import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram_with_provider/resources/auth_methods.dart';
import 'package:instagram_with_provider/resources/firestore_method.dart';
import 'package:instagram_with_provider/responsive/mobilescreen_layout.dart';
import 'package:instagram_with_provider/responsive/responsive_layout_screen.dart';
import 'package:instagram_with_provider/responsive/webscreen_layout.dart';
import 'package:instagram_with_provider/screens/login_screen.dart';

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

  bool isFollowing = false;

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
      isFollowing = fetchUser
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

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
        // leading: IconButton(
        //   onPressed: () => Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(
        //           builder: (_) => const ResponsiveLayout(
        //               webScreenLayout: WebScreenLayout(),
        //               mobileScreenLayout: MobileScreenLayout()))),
        //   icon: const Icon(Icons.arrow_back),
        // ),
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
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? InkWell(
                              onTap: () {
                                AuthMethods().logOuUser();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()));
                                setState(() {});
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                height: 40.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.white),
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: const Center(child: Text("Log Out")),
                              ),
                            )
                          : !isFollowing
                              ? ElevatedButton(
                                  onPressed: () async {
                                    FirestoreMethod().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid']);
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                  },
                                  child: const Center(child: Text("Follow")))
                              : ElevatedButton(
                                  onPressed: () async {
                                    FirestoreMethod().followUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        userData['uid']);

                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  child: const Center(child: Text("Unfollow")))
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
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: widget.uid)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> postData =
                      (snapshot.data! as dynamic).docs[index].data();

                  return Container(
                    child: Image(
                      image: NetworkImage(postData['image_url']),
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: CircularProgressIndicator()),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
