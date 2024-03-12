import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/features/todo_list/controller/todo_operation.dart';
import 'package:date_format/date_format.dart';

import '../../../../utils/local_notification_services.dart';

class AddTodoBottomSheet extends StatefulWidget {
  const AddTodoBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddTodoBottomSheet> createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final _myTextController = TextEditingController();
  int _prio = 1;
  Color? _colour = Colors.grey[700];
  bool _validate = false;
  bool _hasDueDate = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  late String _hour, _minute, _time;
  late String dateTime;
  @override
  void dispose() {
    _myTextController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
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
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double multiplier = 3;
    return AnimatedSize(
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.fastOutSlowIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New To-Do-List',
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
            decoration: kBottomSheetFieldDecoration.copyWith(
              labelText: 'Your To-Do-List',
              errorText: _validate ? 'Value can\'t be Empty' : null,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            cursorColor: kDefaultColor,
            controller: _myTextController,
            autofocus: true,
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
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kDefaultColor,
            ),
            onPressed: () {
              setState(() {
                _myTextController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
              if (!_validate) {
                if (_hasDueDate) {
                  Provider.of<TodoOperation>(context, listen: false)
                      .addTodoWithDate(
                    _myTextController.text,
                    _prio,
                    '${_dateController.text.trim()} ${_timeController.text.trim()}',
                    context,
                  );
                } else {
                  Provider.of<TodoOperation>(context, listen: false)
                      .addTodo(_myTextController.text, _prio);
                }
                LocalNotificationService.setScheduledNotification(
                    context: context);
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
