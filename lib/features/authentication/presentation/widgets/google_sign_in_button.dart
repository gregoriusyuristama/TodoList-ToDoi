// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/common/screen/main_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDefaultColor),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              backgroundColor: kDefaultColor,
            ),
            onPressed: () async {
              setState(() {
                _isSigningIn = true;
              });
              // sign in method
              try {
                User? user =
                    await Authentication.signInWithGoogle(context: context);
                if (user != null) {
                  Navigator.pushReplacementNamed(context, MainScreen.id);
                }
                setState(() {
                  _isSigningIn = false;
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.toString(),
                    ),
                  ),
                );
              }
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: [
                  Image(
                    image: AssetImage("assets/images/google_logo.png"),
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: FittedBox(
                      child: Text(
                        'Login with Google',
                        style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
