import 'package:flutter/material.dart';

class EmptyTodo extends StatelessWidget {
  final double availableHeight;
  final double availableWidth;

  const EmptyTodo(
      {Key? key, required this.availableWidth, required this.availableHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableHeight,
      width: availableWidth,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Icon(
                Icons.pending_actions,
                color: Colors.grey[400],
                size: 80,
              ),
            ),
            Text(
              'Your To Do List is empty,\nLet\'s create new to do !',
              style: TextStyle(color: Colors.grey[500], fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
