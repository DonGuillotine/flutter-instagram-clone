import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Creating Controllers for our custom text input widget @ widgets/text_field.dart
  // `Uint8List? _image` means it can be nullable
  //  isLoading is for a loading indicator

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
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
    _bioController.dispose();
    _usernameController.dispose();
  }

  // Using the 'pickImage function @ utils/utils and passing the value in the 'source argument'
  // Dynamic can be a Unint8List but a Uint8List cannot be a dynamic that's why the type of Unint8List is used
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  // Sign up user function
  void signUpUser() async {
    // As soon as this function is run set the loading state to true
    // So the progress indicator activates
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      //  Code to take user to main page
      //  the state up there provides us with the content
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          // from responsive/...
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    } else {
      // This function takes in the content and context of the showSnackBar function
      // Located @ utils/utils
      showSnackBar(res, context);
    }
  }

  //  Code to take user to sign up page
  //  the state provides us with the context
  void navigateToLogIn() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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

            // Stack enables Widgets to be placed on top of the other
            // Circular Widget to accept image
            Stack(
              children: [
                // If the Image is not null/empty insert selected `_image!`
                // It must not be null

                _image != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage('assets/default-profile-icon-24.jpg'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      // Run the SelectImage function above

                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ))
              ],
            ),

            const SizedBox(height: 24),

            // Text Input for Username
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your Username',
                textInputType: TextInputType.text),

            const SizedBox(height: 24),

            // Text Input for Email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your E-mail',
                textInputType: TextInputType.emailAddress),

            const SizedBox(height: 24),

            // Text Input for Password
            TextFieldInput(
                textEditingController: _passwordController,
                isPass: true,
                hintText: 'Enter your Password',
                textInputType: TextInputType.text),

            const SizedBox(height: 24),

            // Text Input for Bio
            TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your Bio',
                textInputType: TextInputType.text),

            const SizedBox(height: 24),

            // Since button isn't used Inkwell does the job
            // Sign Up area
            InkWell(
              // OnTap of the button run the signUpUser function located at resources/auth_methods-> class AuthMethods
              onTap: signUpUser,
              child: Container(
                //  If _isLoading is true show a loading indicator
                //  else show a normal button
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign In'),
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

            // Option Area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Have an account?'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                // No links so GestureDetector does the job with the onTap property
                GestureDetector(
                  onTap: navigateToLogIn,
                  child: Container(
                    child: const Text(' Log in',
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
