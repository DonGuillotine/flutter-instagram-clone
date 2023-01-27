import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/sign_up_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Creating Controllers for our custom text input widget @ widgets/text_field.dart
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // The aim of this method is to release the resources retained by the object
    // like any controllers, animations, timers, etc
    // when dispose() method gets called, the object is considered as “unmounted” and “mounted” is updated as false
    // This Clears the fields when it is submitted
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  //  Using the AuthMethods class then the logInUser function in resources/auth_methods
  void logInUser() async {
    //  Setting the loading indicator on the button is clicked
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == 'success') {
      //  Code to take user to main page
      //  the state up there provides us with the content
      //  we don't want to go back to the other screen so we use pushReplacement instead of push
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          // from responsive/...
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  //  Code to take user to sign up page
  //  the state up there provides us with the context
  void navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignUpScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // Instagram Logo
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            // Logo
            SvgPicture.asset('assets/ic_instagram.svg',
                color: primaryColor, height: 64),
            const SizedBox(height: 64),
            // Input field for Email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your E-mail',
                textInputType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            // Input field for Password
            TextFieldInput(
                textEditingController: _passwordController,
                isPass: true,
                hintText: 'Enter your Password',
                textInputType: TextInputType.text),
            const SizedBox(height: 24),
            // Since button isn't used Inkwell does the job

            // Login area
            InkWell(
              onTap: logInUser,
              child: Container(
                // If _isLoading is true show progress indicator
                // else show normal button
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Log in'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(child: Container(), flex: 2),
            //  Options Area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Dont\' have an account?'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                // No links so GestureDetector does the job with the onTap property
                GestureDetector(
                  onTap: navigateToSignUp,
                  child: Container(
                    child: const Text(' Sign up',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
