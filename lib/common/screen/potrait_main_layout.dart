import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/string_helper.dart';
import '../widgets/greetings.dart';
import '../widgets/search_todo.dart';
import '../../features/todo_list/presentation/widgets/todo_box.dart';
import '../widgets/todo_counter.dart';

// ignore: must_be_immutable
class PotraitMainLayout extends StatelessWidget {
  MediaQueryData mediaQuery;
  PotraitMainLayout(this.mediaQuery, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    double availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.size.width * 0.025,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: availableHeight * 0.08,
              child: Greetings(
                StringHelper.firstName(
                  user!.isAnonymous ? 'Guest' : user.displayName.toString(),
                ),
                true,
              ),
            ),
            SizedBox(
              height: availableHeight * 0.01,
            ),
            SizedBox(
              height: availableHeight * 0.05,
              child: const TodoCounter(),
            ),
            // SizedBox(
            //   height: availableHeight * 0.055,
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: FittedBox(
            //       child: Text(
            //         StringHelper.formatDate(
            //           DateTime.now(),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: availableHeight * 0.01,
            ),
            Center(
              child: SearchTodo(
                mediaQuery.size.width,
                availableHeight * 0.05,
              ),
            ),
            SizedBox(
              height: availableHeight * 0.01,
            ),
            SizedBox(
              height: availableHeight * 0.78,
              width: mediaQuery.size.width,
              child: const TodoBox(false),
            ),
          ],
        ),
      ),
    );
  }
}
