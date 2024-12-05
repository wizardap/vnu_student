import 'package:flutter/material.dart';

// save for chosen date and monday of that week
class DatetimeHelper {
  DateTime _selectedDate = DateTime.now();
  DateTime curMonday = DateTime.now(); // Ngày đầu tuần hiện tại

  DatetimeHelper() {
    _selectedDate = DateTime.now();
    curMonday = DateTime.now(); // Ngày đầu tuần hiện tại
  }

  // Lấy ngày được chọn
  DateTime getSelectedDate() {
    return _selectedDate;
  }

  // Lấy thứ hai của tuần hiện tại
  DateTime getMonday() {
    return curMonday;
  }

  // Lấy chủ nhật của tuần hiện tại
  DateTime getWeekEnd() {
    return curMonday.add(Duration(days: 6));
  }

  // cập nhật ngày được chọn
  void set(DateTime _pickedDate) {
    _selectedDate = _pickedDate;
    int difference = _selectedDate.weekday - DateTime.monday;
    curMonday = _selectedDate.subtract(Duration(days: difference));
  }

  // Kiểm tra xem tất cả các ngày trong tuần có cùng một năm không
  bool allSameYear() {
    return getWeekEnd().year == curMonday.year;
  }

  // Kiểm tra xem tất cả các ngày trong tuần có cùng một tháng không
  bool allSameMonth() {
    return getWeekEnd().month == curMonday.month;
  }

  // Lấy chỉ số ngày trong tuần của một ngày
  // Ví dụ: Monday -> 1, Tuesday -> 2, ..., Sunday -> 7
  static int getDayIndex(DateTime date) {
    return date.weekday - DateTime.monday + 1;
  }

  // Lấy ngày của một ngày trong tuần
  static int getDay(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).day;
  }

  // Lấy tháng của một ngày trong tuần
  static int getMonth(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).month;
  }

  // Lấy năm của một ngày trong tuần
  static int getYear(int dayIndex, DateTime curMonday) {
    return curMonday.add(Duration(days: dayIndex)).year;
  }
}