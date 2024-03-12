import 'package:intl/intl.dart';

class StringHelper {
  static String firstName(String name) {
    List<String> nameList = name.split(" ");
    if (nameList.isNotEmpty) {
      if (nameList[0].length >= 10) {
        return '${nameList[0].substring(0, 10)}...';
      }
      return nameList[0];
    } else {
      return '';
    }
  }

  static String formatDate(DateTime date) {
    late String day;
    switch (date.weekday) {
      case 1:
        day = 'Monday';
        break;
      case 2:
        day = 'Tuesday';
        break;
      case 3:
        day = 'Wednesday';
        break;
      case 4:
        day = 'Thursday';
        break;
      case 5:
        day = 'Friday';
        break;
      case 6:
        day = 'Saturday';
        break;
      case 7:
        day = 'Sunday';
        break;
    }
    return "$day, ${DateFormat.MMMMd('en_US').format(date)}";
  }

  static String formatDueDate(String date) {
    String dateOnly = date.split(' ')[0];
    String timeOnly = date.substring(dateOnly.length).trim();
    DateTime tempDate = DateFormat("MM/dd/yyyy").parse(dateOnly);
    late String day;
    late String add = 'th';
    switch (tempDate.weekday) {
      case 1:
        day = 'Mon';
        break;
      case 2:
        day = 'Tue';
        break;
      case 3:
        day = 'Wed';
        break;
      case 4:
        day = 'Thu';
        break;
      case 5:
        day = 'Fri';
        break;
      case 6:
        day = 'Sat';
        break;
      case 7:
        day = 'Sun';
        break;
    }
    int numberedDay = tempDate.day;
    if (numberedDay.toString().length == 2) {
      numberedDay = int.parse(numberedDay.toString().substring(1));
    }
    switch (numberedDay) {
      case 1:
        add = 'st';
        break;
      case 2:
        add = 'nd';
        break;
      case 3:
        add = 'rd';
        break;
      default:
        add = 'th';
        break;
    }
    return "$day, ${DateFormat.MMMd('en_US').format(tempDate)}$add $timeOnly";
  }
}
