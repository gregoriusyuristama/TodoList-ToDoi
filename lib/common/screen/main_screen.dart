import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
// import 'package:to_do_list/screen/main_screen/search_todo.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/utils/sharedpref_helper.dart';
import 'package:to_do_list/utils/tablet_detector.dart';
import 'package:to_do_list/common/screen/landscape_main_layout.dart';
import 'package:to_do_list/common/screen/potrait_main_layout.dart';
import '../../utils/local_notification_services.dart';

late User loggedInUser;

class MainScreen extends StatefulWidget {
  static const String id = '/home';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _notificationsEnabled = false;
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await LocalNotificationService.localNotificationService
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            //  critical: true,
          );
      await LocalNotificationService.localNotificationService
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
            // critical: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          LocalNotificationService.localNotificationService
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? granted =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = granted ?? false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!TabletDetector.isTablet(MediaQuery.of(context))) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TodoOperation>(context, listen: false).setTodolist();
    SharedPrefHelper.initDailyNotificationHour();
    LocalNotificationService.initialize();
    final mediaQuery = MediaQuery.of(context);
    final potrait = Orientation.portrait == mediaQuery.orientation;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: kDefaultBackgroundDecoration,
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: potrait
              ? PotraitMainLayout(mediaQuery)
              : const LandscapeMainLayout(),
        ),
      ),
    );
  }
}
