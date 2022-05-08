import 'package:flutter/material.dart';
import 'package:instagram_with_provider/resources/auth_methods.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
