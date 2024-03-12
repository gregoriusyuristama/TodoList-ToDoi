import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/utils/sharedpref_helper.dart';
import 'package:to_do_list/utils/string_helper.dart';
import 'package:to_do_list/common/widgets/greetings.dart';
import '../../utils/local_notification_services.dart';

class AppSettings extends StatelessWidget {
  static const String id = '/settings';
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final user = FirebaseAuth.instance.currentUser;
    double availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    return Scaffold(
      body: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          decoration: kDefaultBackgroundDecoration,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.size.width * 0.025,
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: availableHeight * 0.08,
                    child: Greetings(
                      user!.isAnonymous
                          ? 'Guest'
                          : StringHelper.firstName(user.displayName.toString()),
                      false,
                    ),
                  ),
                  Container(
                    decoration: kTodoBoxDecoration,
                    width: mediaQuery.size.width,
                    height: availableHeight * 0.91,
                    margin: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width * 0.025),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxWidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: SizedBox(
                                height: constraints.maxHeight * 0.08,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth * 0.1,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.arrow_back,
                                          // size: 24,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.05,
                                    ),
                                    Container(
                                      width: constraints.maxWidth * 0.75,
                                      alignment: FractionalOffset.centerLeft,
                                      child: const Text(
                                        'Settings',
                                        style: kTitleToDoBox,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: Text(
                                'Notification',
                                style: kDefaultTextColor.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              height: constraints.maxHeight * 0.025,
                              thickness: 1,
                              color: kDefaultColor,
                            ),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: TextButton(
                                onPressed: () async {
                                  var currentDailyHour = await SharedPrefHelper
                                      .getDailyNotificationHour();
                                  var currentDailyMinutes =
                                      await SharedPrefHelper
                                          .getDailyNotificationMinutes();
                                  TimeOfDay time = TimeOfDay(
                                      hour: currentDailyHour,
                                      minute: currentDailyMinutes);
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: time,
                                  );
                                  if (newTime != null) {
                                    SharedPrefHelper
                                        .changeDailyNotificationHour(
                                      newTime.hour,
                                      newTime.minute,
                                    );
                                    LocalNotificationService
                                        .setScheduledNotification(
                                      context: context,
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Change Daily Notification Time',
                                      style: kDefaultTextColor,
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        color: kDefaultColor),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth,
                              child: Text(
                                'Account',
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Divider(
                              height: constraints.maxHeight * 0.025,
                              thickness: 1,
                              color: Colors.red[300],
                            ),
                            TextButton(
                              onPressed: () {
                                Authentication.confirmationDialog(
                                  context: context,
                                  confirmationText: 'Do you want to log out?',
                                ).then((confirmed) {
                                  if (confirmed) {
                                    Authentication.signOut(context: context);
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.red[300],
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Authentication.confirmationDialog(
                                  context: context,
                                  confirmationText:
                                      'Are you sure do you want to delete you account?',
                                ).then((confirmed) {
                                  if (confirmed) {
                                    Authentication.deleteAccount(
                                        context: context);
                                  }
                                });
                              },
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Delete Account',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.red[300],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
