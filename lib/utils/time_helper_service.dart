// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class TimeHelperService {
  TimeHelperService() {
    setup();
  }

  void setup() async {
    tz.initializeTimeZones();
    final timezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(
        timezone,
      ),
    );
  }

  Future<tz.TZDateTime> getTimeNow() async {
    return tz.TZDateTime.now(
        tz.getLocation(await FlutterTimezone.getLocalTimezone()));
  }
}
