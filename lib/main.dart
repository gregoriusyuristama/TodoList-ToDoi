import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/common/screen/app_settings.dart';
import 'package:to_do_list/features/authentication/presentation/screen/register_screen.dart';
import 'package:to_do_list/features/authentication/presentation/screen/login_screen.dart';
import 'package:to_do_list/common/screen/main_screen.dart';
import 'package:to_do_list/features/authentication/presentation/screen/reset_password.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:to_do_list/common/screen/welcome_screen.dart';
import 'utils/firebase_options.dart';
import 'utils/local_notification_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.initialize();
  runApp(const MyApp());
}

var appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: kDefaultColor,
  useMaterial3: true,
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 32,
    ),
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoOperation(),
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          MainScreen.id: (context) => const MainScreen(),
          RegisterScreen.id: (context) => const RegisterScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          ResetPassword.id: (context) => const ResetPassword(),
          AppSettings.id: (context) => const AppSettings(),
        },
        debugShowCheckedModeBanner: false,
        title: 'ToDoi',
        theme: appTheme,
      ),
    );
  }
}
