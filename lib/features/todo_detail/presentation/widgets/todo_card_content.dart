import 'package:flutter/material.dart';
import 'package:to_do_list/utils/string_helper.dart';

import 'package:to_do_list/common/models/todo.dart';

class CardContent extends StatelessWidget {
  const CardContent(this.todo, {Key? key}) : super(key: key);

  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          todo.todoName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: (isLandscape ? 2 : 1.66) * unitHeightValue,
              decoration: todo.todoDone ? TextDecoration.lineThrough : null,
              color: todo.todoDone ? Colors.red : null),
        ),
        Text(
          'Priority : ${todo.priority.toString()}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: (isLandscape ? 2 : 1.66) * unitHeightValue,
              ),
        ),
        const SizedBox(
          height: 5,
        ),
        todo.hasDueDate()
            ? Container(
                width: (isLandscape ? 20 : 38) * unitWidthValue,
                height: (isLandscape ? 6.5 : 4.5) * unitHeightValue,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  // color: kDefaultColor,
                ),
                child: FittedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    alignment: FractionalOffset.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.5),
                          child: Icon(
                            Icons.calendar_month_outlined,
                            size: 4 * unitHeightValue,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            StringHelper.formatDueDate(todo.dueDate),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 2 * unitHeightValue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
