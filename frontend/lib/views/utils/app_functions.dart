import 'package:intl/intl.dart';

class AppFunctions{
  static String dateTimeFormat(DateTime dateTime) {
    return DateFormat('dd-MMM-yyyy - HH:mm').format(dateTime);
  }
  static String dateFormat(DateTime dateTime) {
    return DateFormat('dd-MMM-yyyy').format(dateTime);
  }
  static String formatDateTime(DateTime dateTime) {
    // Define the date format
    final dateFormat = DateFormat("EEEE, MMMM d 'at' h:mm a");
    return dateFormat.format(dateTime);
  }
}