// ignore_for_file: sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/common/screen/app_settings.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/common/widgets/counter_finished.dart';
import 'package:to_do_list/common/widgets/search_todo.dart';
import 'package:to_do_list/features/todo_list/presentation/widgets/todo_box.dart';

import '../../utils/string_helper.dart';

class LandscapeMainLayout extends StatelessWidget {
  const LandscapeMainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double unitHeightValue = mediaQuery.size.height * 0.01;
    double unitWidthValue = mediaQuery.size.width * 0.01;
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.2,
                    color: const Color.fromRGBO(75, 191, 221, 0.7),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(25, unitHeightValue * 10, 50, 10),
                      child: Text(
                        'Hi, ${StringHelper.firstName(user!.isAnonymous ? 'Guest' : user.displayName.toString())}',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: unitWidthValue * 4),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.03,
                      horizontal: constraints.maxWidth * 0.03,
                    ),
                    child: SearchTodo(
                      constraints.maxWidth,
                      constraints.maxHeight * 0.07,
                    ),
                  ),
                  Container(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight * 0.52,
                    alignment: FractionalOffset.topCenter,
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.03,
                    ),
                    child: Row(
                      children: [
                        CounterLandscape(
                          availableHeight: constraints.maxHeight * 0.05,
                          availableWidth: constraints.maxWidth * 0.45,
                          isFinished: true,
                        ),
                        SizedBox(
                          width: constraints.maxWidth * 0.04,
                        ),
                        CounterLandscape(
                          availableHeight: constraints.maxHeight * 0.05,
                          availableWidth: constraints.maxWidth * 0.45,
                          isFinished: false,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.08,
                    alignment: FractionalOffset.centerLeft,
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton(
                      child: const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppSettings.id),
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.05,
                    padding: const EdgeInsets.only(left: 10),
                    alignment: FractionalOffset.centerLeft,
                    child: TextButton(
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => {
                        Authentication.confirmationDialog(
                          context: context,
                          confirmationText: 'Do you want to log out?',
                        ).then((confirmed) {
                          if (confirmed) {
                            Authentication.signOut(context: context);
                          }
                        })
                      },
                    ),
                  ),
                ],
              ),
              color: const Color.fromRGBO(255, 255, 255, 0.2),
            );
          }),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(unitWidthValue * 9, 50, 0, 50),
            child: const TodoBox(true),
          ),
          flex: 2,
        ),
      ],
    );
  }
}
