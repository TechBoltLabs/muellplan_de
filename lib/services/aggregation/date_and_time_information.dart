// lib/services/aggregation/date_and_time_information.dart

import '../../constants/constants_barrel.dart';

// this method transforms a provided date from the database to an european date format
// but only the day and month
String getEuropeanDate({required String dateString}) {
  // parse the date string to a DateTime object
  DateTime parsedDate = DateTime.parse(dateString);

  // return the date in the european format
  return "${parsedDate.day}.${parsedDate.month}.";
}

// this method gets a date string and returns the corresponding weekday as a String
String getWeekDay({required String date, bool useShortForm = false}) {
  // variable for storing the weekday
  String weekday;
  // if the user wants to use the short form of the weekday
  if (useShortForm) {
    // get the weekday from the date string
    // by using the DateTime.parse(date).weekday method
    // which returns an int from 1 to 7
    // that int is used as an index for the weekDaysShortForms list
    weekday = weekDaysShortForms[DateTime.parse(date).weekday - 1];
  } else {
    // if the user wants to use the long form of the weekday
    // get the weekday from the date string
    // by using the DateTime.parse(date).weekday method
    // which returns an int from 1 to 7
    // that int is used as an index for the weekDays list
    weekday = weekDays[DateTime.parse(date).weekday - 1];
  }
  // return the weekday
  return weekday;
}

// this method gets a timespan as String and returns the corresponding number of days
// for showing future collection dates
int getNumberOfDaysForFutureDates({required int selectedTimeSpanIndex}) {
  // variable for storing the amount of days of
  // the timespan for showing future collection dates
  int numberOfDays;
  // variable to get the timespan String, which the user selected
  String selectedTimeSpan = timeSpansForFutureDates[selectedTimeSpanIndex];
  // if the user selected something with 'Woche'
  if (selectedTimeSpan.contains('Woche')) {
    // set the number of days to weekAmount * 7
    numberOfDays = int.parse(selectedTimeSpan.split(' ')[0]) * 7;
    // if the user selected something with 'Monat'
  } else if (selectedTimeSpan.contains('Monat')) {
    // set the number of days to monthAmount * 30
    numberOfDays = int.parse(selectedTimeSpan.split(' ')[0]) * 30;
  } else if (selectedTimeSpan.contains('alle dieses Jahr')) {
    // if the user selected 'alle dieses Jahr'
    // get the current day
    DateTime now = DateTime.now();
    // get the last day of the current year:
    //   - first create DateTime object of the 01. January of the following year
    //   - then subtract one day from that
    DateTime lastDayOfCurrentYear =
        DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));
    // calculate the difference between the current day and
    // the last day of the current year in days
    // add 1 day because the current day is not being included in the difference
    numberOfDays = lastDayOfCurrentYear.difference(now).inDays + 1;
  } else {
    // if user didn't select anything or something went wrong
    // set the number of days to 0
    numberOfDays = 0;
  }

  // return the number of days
  return numberOfDays;
}
