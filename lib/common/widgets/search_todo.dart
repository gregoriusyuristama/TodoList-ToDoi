import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';

class SearchTodo extends StatefulWidget {
  final double availableHeight;
  final double availableWidth;

  const SearchTodo(this.availableWidth, this.availableHeight, {Key? key})
      : super(key: key);

  @override
  State<SearchTodo> createState() => _SearchTodoState();
}

class _SearchTodoState extends State<SearchTodo> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _controller.text.isNotEmpty;
    double unitValueHeight = widget.availableHeight * 0.01;
    return Container(
      width: widget.availableWidth,
      height: widget.availableHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(50),
              color: Colors.transparent,
            ),
            width: widget.availableWidth * 0.15,
            height: 70,
            child: Center(
              child: FittedBox(
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ),
          ),
          SizedBox(
            width: widget.availableWidth * 0.75,
            child: Stack(
              alignment: const Alignment(
                1.0,
                0.0,
              ),
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search to do list...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: unitValueHeight * 30,
                    ),
                  ),
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: unitValueHeight * 30,
                  ),
                  onChanged: (value) {
                    setState(() {
                      Provider.of<TodoOperation>(context, listen: false)
                          .changeSearchString(value);
                    });
                  },
                ),
                AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Visibility(
                      visible: isSearching,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.clear();
                            Provider.of<TodoOperation>(context, listen: false)
                                .changeSearchString(_controller.text);
                          });
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
