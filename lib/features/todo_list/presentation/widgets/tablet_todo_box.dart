import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import '../../../../utils/constants.dart';
import 'add_todo_bottom_sheet.dart';
import 'add_todo_button.dart';
import 'empty_todo.dart';
import '../../../todo_detail/presentation/widgets/todo_card.dart';

class TabletTodoBoxLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final bool showUnfinished;
  final TodoOperation bloc;
  final bool isLandscape;
  const TabletTodoBoxLayout(
      this.constraints, this.showUnfinished, this.bloc, this.isLandscape,
      {Key? key})
      : super(key: key);

  @override
  State<TabletTodoBoxLayout> createState() => _TabletTodoBoxLayoutState();
}

class _TabletTodoBoxLayoutState extends State<TabletTodoBoxLayout> {
  late bool _showUnfinished;
  @override
  void initState() {
    super.initState();
    _showUnfinished = widget.showUnfinished;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = widget.constraints.maxHeight * 0.01;
    double multiplier = widget.isLandscape ? 4 : 3;
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: widget.constraints.maxHeight * 0.125,
              // width: constraints.maxWidth,
              padding: kTitleWidgetCardPadding,
              alignment: FractionalOffset.centerLeft,
              child: FittedBox(
                child: Text(
                  'Your To Do List',
                  style: kTitleToDoBox.copyWith(
                    fontSize: multiplier * unitHeightValue,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: widget.constraints.maxHeight * 0.125,
              padding: kTitleWidgetCardPadding,
              alignment: FractionalOffset.centerLeft,
              child: FittedBox(
                child: AddTodoButton(
                  Icons.add,
                  () => showDialog(
                    context: context,
                    builder: ((context) {
                      return const AlertDialog(
                        scrollable: true,
                        content: Padding(
                          padding: EdgeInsets.all(25),
                          child: AddTodoBottomSheet(),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(
          height: widget.constraints.maxHeight * 0.025,
          thickness: 1,
        ),
        AnimatedSize(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.fastOutSlowIn,
          child: _showUnfinished
              ? Container(
                  height: widget.constraints.maxHeight * 0.775,
                  width: widget.constraints.maxWidth,
                  alignment: Alignment.center,
                  child: widget.bloc.unfinishedTodolist.isEmpty
                      ? EmptyTodo(
                          availableHeight: widget.constraints.maxHeight * 0.65,
                          availableWidth: widget.constraints.maxWidth,
                        )
                      : ListView.builder(
                          itemCount: widget.bloc.unfinishedTodolist.length,
                          itemBuilder: (context, index) {
                            final todoItem =
                                widget.bloc.unfinishedTodolist[index];
                            return TodoCard(
                              widget.constraints.maxWidth,
                              widget.constraints.maxHeight,
                              todoItem,
                              () {
                                widget.bloc.doneTodo(todoItem);
                              },
                            );
                          },
                        ),
                )
              : SizedBox(
                  width: widget.constraints.maxWidth,
                ),
        ),
        Expanded(
          child: Material(
            borderRadius: widget.isLandscape
                ? kBorderRadiusFinishedLandscape
                : const BorderRadius.all(Radius.circular(40)),
            child: InkWell(
              borderRadius: widget.isLandscape
                  ? kBorderRadiusFinishedLandscape
                  : BorderRadius.all(Radius.circular(_showUnfinished ? 40 : 0)),
              onTap: () {
                setState(() {
                  _showUnfinished = !_showUnfinished;
                });
              },
              child: Container(
                height: widget.constraints.maxHeight * 0.07,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: widget.isLandscape
                      ? kBorderRadiusFinishedLandscape
                      : const BorderRadius.all(Radius.circular(40)),
                  border: widget.isLandscape
                      ? Border.all(
                          width: 0.5,
                          color: const Color.fromRGBO(207, 207, 207, 1),
                        )
                      : const Border(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<TodoOperation>(
                      builder: (context, todoData, child) => Text(
                        'Finished (${todoData.finishedTodoCount})',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 2 * unitHeightValue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      _showUnfinished
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.fastOutSlowIn,
          child: !_showUnfinished
              ? Container(
                  height: widget.constraints.maxHeight * 0.775,
                  width: widget.constraints.maxWidth,
                  alignment: Alignment.center,
                  child: widget.bloc.finishedTodolist.isEmpty
                      ? EmptyTodo(
                          availableHeight: widget.constraints.maxHeight * 0.65,
                          availableWidth: widget.constraints.maxWidth,
                        )
                      : ListView.builder(
                          itemCount: widget.bloc.finishedTodoCount,
                          itemBuilder: (context, index) {
                            final todoItem =
                                widget.bloc.finishedTodolist[index];
                            return TodoCard(
                              widget.constraints.maxWidth,
                              widget.constraints.maxHeight,
                              todoItem,
                              () {
                                widget.bloc.doneTodo(todoItem);
                              },
                            );
                          },
                        ),
                )
              : SizedBox(
                  width: widget.constraints.maxWidth,
                ),
        ),
      ],
    );
  }
}
