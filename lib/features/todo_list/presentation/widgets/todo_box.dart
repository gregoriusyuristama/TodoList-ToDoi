import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:to_do_list/utils/tablet_detector.dart';
import 'package:to_do_list/features/todo_list/presentation/widgets/phone_todo_box.dart';
import 'package:to_do_list/features/todo_list/presentation/widgets/tablet_todo_box.dart';

class TodoBox extends StatefulWidget {
  final bool isLandscape;
  const TodoBox(this.isLandscape, {Key? key}) : super(key: key);

  @override
  State<TodoBox> createState() => _TodoBoxState();
}

class _TodoBoxState extends State<TodoBox> {
  bool showUnfinished = true;
  User? loggedInUser = FirebaseAuth.instance.currentUser;
  late TodoOperation _bloc;
  late bool isTablet;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MediaQueryData mediaQuery = MediaQuery.of(context);
    isTablet = TabletDetector.isTablet(mediaQuery);
  }

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<TodoOperation>(context);
    return Container(
      decoration:
          // widget.isLandscape ? kTodoBoxDecorationLandscape :
          kTodoBoxDecoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return (isTablet || Platform.isMacOS)
              ? TabletTodoBoxLayout(
                  constraints,
                  showUnfinished,
                  _bloc,
                  widget.isLandscape,
                )
              : PhoneTodoBoxLayout(
                  constraints,
                  showUnfinished,
                  _bloc,
                );
        },
      ),
    );
  }
}
