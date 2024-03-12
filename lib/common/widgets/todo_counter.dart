import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:to_do_list/utils/constants.dart';

var backgroundCardDecoration = BoxDecoration(
  color: const Color.fromRGBO(246, 164, 97, 1.0),
  borderRadius: BorderRadius.circular(50),
);

class TodoCounter extends StatelessWidget {
  const TodoCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoOperation>(
      builder: (context, todoData, child) => FittedBox(
        child: Container(
          decoration: backgroundCardDecoration,
          width: 200,
          height: 50,
          child: Row(
            children: [
              Container(
                margin: kCounterCardMargin,
                decoration: kCounterCardDecoration,
                width: kCounterCardWidth,
                height: kCounterCardHeight,
                child: counterText(todoData.unFinishedTodoCount.toString()),
              ),
              const SizedBox(
                width: 20,
              ),
              textTitle('Unfinished'),
            ],
          ),
        ),
      ),
    );
  }

  Center textTitle(String text) {
    return Center(
      child: FittedBox(
        child: Text(
          text,
          style: kCounterTitleTextStyle,
        ),
      ),
    );
  }

  Center counterText(String text) {
    return Center(
      child: FittedBox(
        child: Text(
          text,
          style: kCounterTextStyle,
        ),
      ),
    );
  }
}
