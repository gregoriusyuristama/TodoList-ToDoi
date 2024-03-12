// ignore_for_file: use_build_context_synchronously
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/features/authentication/presentation/screen/login_screen.dart';
import 'package:to_do_list/features/authentication/presentation/screen/register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io' show Platform;

import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import '../../utils/authentication_exception.dart';
// import '../widget/google_sign_in_button.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'id';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  ImageProvider googleLogo = const AssetImage('assets/images/google_logo.png');
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(googleLogo, context);
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('emailSignIn');

    try {
      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
        final Uri deepLink = dynamicLinkData.link;
        await Authentication.handleSignInLink(deepLink, userEmail, context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return ChangeNotifierProvider.value(
      value: TodoOperation(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: kDefaultBackgroundDecoration,
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: ProgressHUD(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Column(
                        children: [
                          DefaultTextStyle(
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      fontSize: 40,
                                    ),
                            textAlign: TextAlign.center,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                WavyAnimatedText(
                                  'To Do List : ToDoi',
                                ),
                              ],
                              isRepeatingAnimation: true,
                              repeatForever: true,
                            ),
                          ),
                          const Text(
                            'Manage your day',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Hero(
                      tag: 'cardContainer',
                      child: Center(
                        child: SizedBox(
                          width: 400,
                          child: Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: FutureBuilder(
                                future: Authentication.initializeFirebase(
                                    context: context),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Error initializing Firebase');
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  Platform.isMacOS ? 15 : 0),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              try {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      e.toString(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kDefaultColor,
                                              minimumSize:
                                                  const Size.fromHeight(40),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8.0,
                                                  ),
                                                  child: const Icon(
                                                    Icons.email,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const FittedBox(
                                                  child: Text(
                                                    'Login with Email',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        !Platform.isMacOS
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize:
                                                      const Size.fromHeight(40),
                                                  backgroundColor:
                                                      kDefaultColor,
                                                ),
                                                onPressed: () async {
                                                  final progress =
                                                      ProgressHUD.of(context);
                                                  progress?.show();
                                                  // sign in method
                                                  try {
                                                    await Authentication
                                                        .signInWithGoogle(
                                                            context: context);
                                                    await Provider.of<
                                                                TodoOperation>(
                                                            context,
                                                            listen: false)
                                                        .setTodolist();
                                                    await Navigator
                                                        .pushReplacementNamed(
                                                            context,
                                                            MainScreen.id);

                                                    progress?.dismiss();
                                                  } catch (e) {
                                                    progress?.dismiss();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          e.toString(),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 10),
                                                  child: Row(
                                                    children: [
                                                      ImageIcon(
                                                        googleLogo,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.0),
                                                        child: FittedBox(
                                                          child: Text(
                                                            'Login with Google',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                        (Platform.isIOS)
                                            ? ElevatedButton(
                                                onPressed: () async {
                                                  final progress =
                                                      ProgressHUD.of(context);
                                                  progress?.show();
                                                  try {
                                                    final user =
                                                        await Authentication
                                                            .signInWithApple(
                                                                context:
                                                                    context);
                                                    if (user != null) {
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                      // Navigator.of(context)
                                                      //     .pushReplacement(
                                                      //         MaterialPageRoute(
                                                      //   builder: (context) =>
                                                      //       MainScreen(),
                                                      // ));
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              MainScreen.id);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                            'Error couldn\'t sign in.',
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    progress?.dismiss();
                                                  } catch (e) {
                                                    progress?.dismiss();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Error couldn\'t sign in.',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kDefaultColor,
                                                  minimumSize:
                                                      const Size.fromHeight(40),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: const [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        right: 8.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.apple,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        'Sign In With Apple',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            bool understand = false;
                                            final progress =
                                                ProgressHUD.of(context);
                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text(
                                                  'Warning',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                content: const Text(
                                                  'When login anonymously your to do list won\'t be saved and deleted immediately after you logged out',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      return;
                                                    },
                                                    child: const Text(
                                                      'Cancel',
                                                      style: kDefaultTextColor,
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      understand = true;
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Ok, I understand',
                                                      style: kDefaultTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            if (understand) {
                                              try {
                                                progress?.show();
                                                final signInStatus =
                                                    await Authentication
                                                        .signInAnonymousely(
                                                            context: context);
                                                if (signInStatus ==
                                                    AuthStatus.successful) {
                                                  await Provider.of<
                                                              TodoOperation>(
                                                          context,
                                                          listen: false)
                                                      .setTodolist();
                                                  progress?.dismiss();
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                  // Navigator.of(context)
                                                  //     .pushReplacement(
                                                  //         MaterialPageRoute(
                                                  //   builder: (context) =>
                                                  //       MainScreen(),
                                                  // ));
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          MainScreen.id);
                                                } else {
                                                  progress?.dismiss();
                                                  final error =
                                                      AuthExceptionHandler
                                                          .generateErrorMessage(
                                                              signInStatus);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        error,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                progress?.dismiss();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      e.toString(),
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kDefaultColor,
                                            minimumSize:
                                                const Size.fromHeight(40),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  'Login Anonymously',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const Center(
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          kDefaultColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // FutureBuilder(
                    //   future: Authentication.initializeFirebase(
                    //       context: context),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasError) {
                    //       return const Text(
                    //           'Error initializing Firebase');
                    //     } else if (snapshot.connectionState ==
                    //         ConnectionState.done) {
                    //       return const GoogleSignInButton();
                    //     }
                    //     return const CircularProgressIndicator(
                    //       valueColor: AlwaysStoppedAnimation<Color>(
                    //         kDefaultColor,
                    //       ),
                    //     );
                    //   },
                    // ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        "Don't have an account?",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDefaultColor,
                        // minimumSize: Size.fromHeight(40),
                        // side: BorderSide(
                        //   color: Colors.white,
                        //   width: 1,
                        // ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
