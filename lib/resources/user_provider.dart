import 'package:flutter/material.dart';
import 'package:videosdk_flutter_example/models/user.dart';
import 'package:videosdk_flutter_example/resources/auth_methods.dart';

class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}