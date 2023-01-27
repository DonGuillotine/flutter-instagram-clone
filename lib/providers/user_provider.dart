import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';

// We are inheriting all properties of the ChangeNotifier class
class UserProvider with ChangeNotifier {
  User? _user;
  //  Initializing the AuthMethods class
  final AuthMethods _authMethods = AuthMethods();

  // A function that returns _user! which can be nullable
  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;

    // This notifies all the listeners in this provider that the data of the global variable user has changed, so updates are made
    notifyListeners();
  }
}
