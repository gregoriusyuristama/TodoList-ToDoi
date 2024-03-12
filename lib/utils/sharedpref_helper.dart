import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static changeDailyNotificationHour(int hour, int minutes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyHour', hour);
    prefs.setInt('dailyMinutes', minutes);
  }

  static Future<void> initDailyNotificationHour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('dailyHour') == null) {
      prefs.setInt('dailyHour', 8);
    }
    if (prefs.getInt('dailyMinutes') == null) {
      prefs.setInt('dailyMinutes', 0);
    }
  }

  static Future<int> getDailyNotificationHour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('dailyHour') ?? 8;
  }

  static Future<int> getDailyNotificationMinutes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('dailyMinutes') ?? 0;
  }
}
