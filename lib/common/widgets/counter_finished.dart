import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:to_do_list/utils/constants.dart';

class CounterLandscape extends StatelessWidget {
  final bool isFinished;
  final double availableHeight;
  final double availableWidth;
  const CounterLandscape(
      {required this.availableHeight,
      required this.availableWidth,
      required this.isFinished,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoOperation>(
      builder: (context, todoData, child) => FittedBox(
        child: Container(
          decoration: BoxDecoration(
            color: isFinished
                ? const Color.fromRGBO(246, 106, 97, 1)
                : const Color.fromRGBO(246, 164, 97, 1.0),
            borderRadius: BorderRadius.circular(40),
          ),
          width: availableWidth,
          height: availableHeight,
          child: Row(
            children: [
              Container(
                margin: kCounterCardMargin,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(40),
                  color: isFinished
                      ? const Color.fromRGBO(244, 132, 132, 1.0)
                      : const Color.fromRGBO(244, 183, 132, 1.0),
                ),
                width: kCounterCardWidth,
                height: kCounterCardHeight,
                child: counterText(isFinished
                    ? todoData.finishedTodoCount.toString()
                    : todoData.unFinishedTodoCount.toString()),
              ),
              const SizedBox(
                width: 20,
              ),
              FittedBox(
                child: Text(
                  isFinished ? 'Finished' : 'Unfinished',
                  textAlign: TextAlign.right,
                  style: kCounterTitleTextStyle,
                ),
              ),
            ],
          ),
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
