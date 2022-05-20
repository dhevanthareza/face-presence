import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppDateUtils {
  static String format(String format, DateTime date) {
    initializeDateFormatting("");
    Intl.defaultLocale = "id";
    return DateFormat(format).format(date);
  }

  static String formatFromString(
    String? tanggal, {
    String? format = "yMMMMd",
    int? addMinutes,
    int? addHours,
  }) {
    if (tanggal != null && tanggal != "" && tanggal != "null") {
      DateTime date = DateTime.parse(tanggal.toString());
      if (addMinutes != null) {
        date = date.add(Duration(minutes: addMinutes));
      }
      if (addHours != null) {
        date = date.add(Duration(hours: addHours));
      }
      return AppDateUtils.format(format!, date);
    } else {
      return "-";
    }
  }
}
