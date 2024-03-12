import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';

import 'package:to_do_list/common/models/todo.dart';
import '../../../../utils/local_notification_services.dart';

class EditTodoBottomSheet extends StatefulWidget {
  const EditTodoBottomSheet({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final ToDo todo;

  @override
  State<EditTodoBottomSheet> createState() => _EditTodoBottomSheet();
}

class _EditTodoBottomSheet extends State<EditTodoBottomSheet> {
  int _prio = 1;
  bool _hasDueDate = false;
  Color? _colour = Colors.grey[700];
  Color? _labelTextColour = Colors.grey[700];
  bool _validate = false;

  var _myTextController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  late String _hour, _minute, _time;
  late String dateTime;
  @override
  void initState() {
    _myTextController = TextEditingController(text: widget.todo.todoName);
    _prio = widget.todo.priority;
    _hasDueDate = widget.todo.hasDueDate();
    if (widget.todo.hasDueDate()) {
      String dateOnly = widget.todo.dueDate.split(' ')[0];
      DateTime tempDate = DateFormat.yMd().parse(dateOnly);
      String timeOnly = widget.todo.dueDate.substring(dateOnly.length).trim();
      _dateController.text = DateFormat.yMd().format(tempDate);
      if (timeOnly.length == 8) {
        String indicator = timeOnly.substring(6);
        int hour = int.parse(timeOnly.substring(0, 2));
        if (indicator == 'PM' && hour != 12) {
          hour += 12;
        }
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, hour, int.parse(timeOnly.substring(3, 5))),
            [hh, ':', nn, " ", am]).toString();
      } else {
        String indicator = timeOnly.substring(4);
        int hour = int.parse(timeOnly.substring(0, 1));
        if (indicator == 'PM' && hour != 12) {
          hour += 12;
        }
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, hour, int.parse(timeOnly.substring(2, 4))),
            [hh, ':', nn, " ", am]).toString();
      }
    } else {
      _dateController.text = DateFormat.yMd().format(DateTime.now());
      _timeController.text = formatDate(
          DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
          [hh, ':', nn, " ", am]).toString();
    }
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour : $_minute';
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  @override
  void dispose() {
    _myTextController.dispose();
    _timeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 3;
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit To-Do-List',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kDefaultColor,
              fontWeight: FontWeight.bold,
              fontSize: multiplier * unitHeightValue,
            ),
          ),
          const Divider(
            thickness: 2.0,
            color: kDefaultColor,
          ),
          TextField(
            decoration: InputDecoration(
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kDefaultColor),
              ),
              hintStyle: const TextStyle(backgroundColor: kDefaultColor),
              fillColor: kDefaultColor,
              labelText: 'Your To-do-list : ',
              errorText: _validate ? 'Value Can\'t be Empty' : null,
              floatingLabelStyle: TextStyle(color: _labelTextColour),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            cursorColor: kDefaultColor,
            controller: _myTextController,
            autofocus: true,
            onSubmitted: (value) {
              setState(() {
                _labelTextColour = Colors.grey[700];
              });
            },
            onTap: () {
              setState(() {
                _labelTextColour = kDefaultColor;
              });
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Priority : ',
            style: TextStyle(
              color: _colour,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.left,
          ),
          Slider(
            activeColor: kDefaultColor,
            value: _prio.toDouble(),
            label: _prio.toInt().toString(),
            min: 1.0,
            max: 5.0,
            divisions: 4,
            onChangeEnd: (value) {
              setState(() {
                _colour = Colors.grey[700];
              });
            },
            onChanged: (double newValue) {
              setState(
                () {
                  _colour = kDefaultColor;
                  _prio = newValue.toInt();
                },
              );
            },
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _hasDueDate = !_hasDueDate;
                  });
                },
                icon: Icon(
                  !_hasDueDate
                      ? Icons.check_box_outline_blank_outlined
                      : Icons.check_box,
                  color: kDefaultColor,
                ),
              ),
              const Text(
                'Have Due Date',
                style: TextStyle(color: kDefaultColor),
              )
            ],
          ),
          Visibility(
            visible: _hasDueDate,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'DATE',
                      style: TextStyle(
                        color: kDefaultColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: kDefaultColor,
                            )),
                        child: Text(
                          _dateController.text,
                          style: const TextStyle(
                            color: kDefaultColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    const Text(
                      'TIME',
                      style: TextStyle(
                        color: kDefaultColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: kDefaultColor,
                            )),
                        child: Text(
                          _timeController.text,
                          style: const TextStyle(
                            color: kDefaultColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () {
                    LocalNotificationService.deleteDoneNotification(
                        widget.todo);
                    Provider.of<TodoOperation>(
                      context,
                      listen: false,
                    ).deleteTodo(widget.todo);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _myTextController.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                    });
                    if (!_validate) {
                      widget.todo.todoName = _myTextController.text;
                      widget.todo.priority = _prio;
                      if (_hasDueDate) {
                        widget.todo.dueDate =
                            '${_dateController.text} ${_timeController.text}';
                        Provider.of<TodoOperation>(
                          context,
                          listen: false,
                        ).updateTodoWithDate(widget.todo);
                        LocalNotificationService.setDueDateNotification(
                            context: context, td: widget.todo);
                      } else {
                        if (widget.todo.hasDueDate()) {
                          ToDo newTodo = widget.todo;
                          newTodo.dueDate = 'no';
                          Provider.of<TodoOperation>(context, listen: false)
                              .deleteTodo(widget.todo);
                          Provider.of<TodoOperation>(context, listen: false)
                              .addTodo(newTodo.todoName, newTodo.priority);
                        } else {
                          Provider.of<TodoOperation>(
                            context,
                            listen: false,
                          ).updateTodo(widget.todo);
                        }
                      }
                      LocalNotificationService.setScheduledNotification(
                          context: context);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: kDefaultColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
