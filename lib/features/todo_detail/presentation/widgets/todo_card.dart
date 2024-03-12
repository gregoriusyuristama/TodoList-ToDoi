import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:to_do_list/utils/tablet_detector.dart';
import 'package:to_do_list/features/todo_detail/presentation/widgets/edit_todo_bottom_sheet.dart';

import 'package:to_do_list/common/models/todo.dart';
import '../../../../../utils/local_notification_services.dart';
import 'todo_card_content.dart';

const cardPadding = EdgeInsets.all(
  10,
);
var cardBoxDecorator = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(40),
  border: Border.all(
    color: Colors.black.withAlpha(50),
  ),
);

const contentPadding = EdgeInsets.only(left: 25.0);

class TodoCard extends StatelessWidget {
  final double width;
  final double height;
  final ToDo todo;
  final Function doneTd;
  const TodoCard(this.width, this.height, this.todo, this.doneTd, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    bool isTablet = TabletDetector.isTablet(mediaQuery);
    return Container(
      padding: cardPadding,
      margin: EdgeInsets.symmetric(
          horizontal: (isTablet || Platform.isMacOS) ? 25 : 5),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => (isTablet || Platform.isMacOS)
              ? showDialog(
                  context: context,
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.vertical(
                  //     top: Radius.circular(25.0),
                  //   ),
                  // ),
                  // isScrollControlled: true,
                  builder: ((context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).viewInsets.left + 25,
                          MediaQuery.of(context).viewInsets.top + 25,
                          MediaQuery.of(context).viewInsets.right + 25,
                          10,
                        ),
                        child: EditTodoBottomSheet(
                          todo: todo,
                        ),
                      ),
                    );
                  }),
                )
              : showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: ((context) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).viewInsets.left + 25,
                        MediaQuery.of(context).viewInsets.top + 25,
                        MediaQuery.of(context).viewInsets.right + 25,
                        MediaQuery.of(context).viewInsets.bottom + 10,
                      ),
                      child: EditTodoBottomSheet(
                        todo: todo,
                      ),
                    );
                  }),
                ),
          child: Ink(
            height: todo.hasDueDate()
                ? unitHeightValue * (isLandscape ? 20 : 14.5)
                : unitHeightValue * 10,
            width: 400,
            decoration: cardBoxDecorator,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: contentPadding,
                    child: CardContent(todo),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Consumer<TodoOperation>(
                      builder: (context, todoData, child) => IconButton(
                          icon: Icon(todo.todoDone
                              ? Icons.check_circle
                              : Icons.check_circle_outline),
                          onPressed: () {
                            todoData.doneTodo(todo);
                            if (todo.todoDone) {
                              LocalNotificationService.deleteDoneNotification(
                                  todo);
                            }
                            LocalNotificationService.setScheduledNotification(
                                context: context);
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
