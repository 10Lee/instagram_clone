import 'package:flutter/material.dart';
import 'package:instagram_with_provider/screens/feed_screen.dart';

import '../screens/addpost_screen.dart';

const webScreenSize = 600;
const homeScreenItems = [
  FeedScreen(),
  Center(child: Text('Seach')),
  AddPostScreen(),
  Center(child: Text('Favorite')),
  Center(child: Text('Profile')),
];
