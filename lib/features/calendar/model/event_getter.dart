import 'package:flutter/material.dart';


class EventGetter {
  // Dữ liệu sự kiện (dayIndex, startHour, duration)
  final List<Map<String, dynamic>> sampleEvents = [
    {
      'date': DateTime(2024, 11, 27),
      'startHour': 10,
      'duration': 2,
      'headerValue': "Sự kiện 1",
      'place': "G2"
    }, // Event trên Wednesday
    {
      'date': DateTime(2024, 11, 29),
      'startHour': 15,
      'duration': 1,
      'headerValue': "Sự kiện 2",
      'place': "G3"
    }, // Event trên Friday
    {
      'date': DateTime(2024, 12, 06),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 3",
      'place': "GĐ2"
    }, // Event trên // Event trên Friday
    {
      'date': DateTime(2024, 12, 05),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 4",
      'place': "GĐ3"
    }, // Tuesday
    {
      'date': DateTime(2024, 11, 30),
      'startHour': 8,
      'duration': 3,
      'headerValue': "Sự kiện 5",
      'place': "GĐ4"
    }, // Tuesd
  ];

  
  EventGetter() {}

  // Lấy các sự kiện trong khoảng thời gian từ startDate đến endDate
  List<Map<String, dynamic>> getEvents(DateTime startDate, DateTime endDate) {
    return getSampleEvents(startDate, endDate);
  }

  List<Map<String, dynamic>> getSampleEvents(DateTime startDate, DateTime endDate) {
    List<Map<String, dynamic>> events = [];
    for (var event in sampleEvents) {
      if (event['date'].isAfter(startDate.subtract(const Duration(days: 1))) &&
          event['date'].isBefore(endDate.add(const Duration(days: 1)))) {
        events.add(event);
      }
    }
    return events;
  }
}