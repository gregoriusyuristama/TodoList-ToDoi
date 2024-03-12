import 'package:flutter/material.dart';

const bottomPadding = EdgeInsets.only(left: 25.0, right: 25);

class AddTodoButton extends StatelessWidget {
  final IconData icon;
  final Function func;

  const AddTodoButton(this.icon, this.func, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bottomPadding,
      child: FittedBox(
        child: IconButton(
          icon: Icon(
            icon,
            size: 30,
          ),
          onPressed: () => func(),
        ),
      ),
    );
  }
}

// void startAddTodo(BuildContext context, Function func) {
//   showModalBottomSheet(
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(25.0),
//       ),
//     ),
//     isScrollControlled: true,
//     builder: (context) {
//       // var availableHeight = MediaQuery.of(context).size.height * 0.45;
//       // var availableWidth = MediaQuery.of(context).size.width;
//       return Padding(
//         padding: EdgeInsets.fromLTRB(
//           MediaQuery.of(context).viewInsets.left + 25,
//           MediaQuery.of(context).viewInsets.top + 25,
//           MediaQuery.of(context).viewInsets.right + 25,
//           MediaQuery.of(context).viewInsets.bottom + 25,
//         ),
//         child: TodoBottomSheet(
//             bottomSheetTitleText: 'Add New To-Do-List', onTap: func),
//       );
//     },
//   );
// }
