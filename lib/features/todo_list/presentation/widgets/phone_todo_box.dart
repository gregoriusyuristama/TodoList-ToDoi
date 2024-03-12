import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';

import '../../../../utils/constants.dart';
import 'add_todo_bottom_sheet.dart';
import 'add_todo_button.dart';
import 'empty_todo.dart';
import '../../../todo_detail/presentation/widgets/todo_card.dart';

class PhoneTodoBoxLayout extends StatefulWidget {
  final BoxConstraints constraints;
  final bool showUnfinished;
  final TodoOperation bloc;
  const PhoneTodoBoxLayout(this.constraints, this.showUnfinished, this.bloc,
      {Key? key})
      : super(key: key);

  @override
  State<PhoneTodoBoxLayout> createState() => _PhoneTodoBoxLayoutState();
}

class _PhoneTodoBoxLayoutState extends State<PhoneTodoBoxLayout> {
  late bool _showUnfinished;
  @override
  void initState() {
    super.initState();
    _showUnfinished = widget.showUnfinished;
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 3;
    return Column(
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
                  height: widget.constraints.maxHeight * 0.675,
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
        Material(
          child: InkWell(
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
        AnimatedSize(
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.fastOutSlowIn,
          child: !_showUnfinished
              ? Container(
                  height: widget.constraints.maxHeight * 0.675,
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
        Divider(
          height: widget.constraints.maxHeight * 0.005,
          thickness: 1,
        ),
        Container(
          height: widget.constraints.maxHeight * 0.1,
          width: widget.constraints.maxWidth,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AddTodoButton(
                FontAwesomeIcons.solidSquarePlus,
                () => showModalBottomSheet(
                  context: context,
                  shape: kModalBotomSheetShape,
                  isScrollControlled: true,
                  builder: ((context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).viewInsets.left + 25,
                          MediaQuery.of(context).viewInsets.top + 25,
                          MediaQuery.of(context).viewInsets.right + 25,
                          MediaQuery.of(context).viewInsets.bottom + 25,
                        ),
                        child: const AddTodoBottomSheet(),
                      ),
                    );
                  }),
                ),
              ),
              // IconButton(
              //     icon: Icon(FontAwesomeIcons.noteSticky),
              //     onPressed: () async {
              //       int totalTodos = todoData.unDoneTodoCount;
              //       await LocalNotificationService.showNotification(
              //         id: 0,
              //         title: 'You have $totalTodos Unfinished To Do(s)',
              //         body: 'Let\'s finish it all!',
              //       );
              //     }),
            ],
          ),
        ),
      ],
    );
  }
}
