import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  // instantiated these variables in the constructor `Responsive Layout`
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout(
      {Key? key,
      required this.webScreenLayout,
      required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  //  InitState() is used to subscribe to the object
  //  While a page gets created on screen, this method gets called at very first.
  //  addData() runs
  void initState() {
    super.initState();
    addData();
  }

  //  the refreshUser() executes if it detects an update in our users | providers/user_provider.dart
  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    // Layout builder helps with responsiveness
    // `constraints` provide us with values such as maxWidth, maxHeight etc
    // webScreenSize is from utils/global_variables.dart for dynamic values
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      }
      return widget.mobileScreenLayout;
    });
  }
}
