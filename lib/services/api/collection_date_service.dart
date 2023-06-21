// lib/services/api/collection_date_service.dart

import 'dart:convert';
import 'package:muellplan_de/services/api/general.dart';
import 'package:muellplan_de/constants/constants_barrel.dart';
import 'package:muellplan_de/notifiers/map_and_location_notifier.dart';

Future<void> fetchCollectionDates(MapAndLocationNotifier notifier,
    String locationName, String streetName) async {

  // variables for the http request URL
  String locationCode = notifier.fetchedLocations[locationName]!;
  String streetCode = notifier.fetchedStreets[streetName]!;

  DateTime now = DateTime.now();
  String today =
      "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

  // the URL for the http request
  String collectionDatesURL = "$backendHost/collection-dates/$locationCode/$streetCode/$today";

  String collectionDatesString = await fetchDocument(collectionDatesURL);

  Map<String, List<String>> collectionDates =
  parseCollectionDatesData(collectionDatesString);

  notifier.setCollectionDates(collectionDates);
}

Map<String, List<String>> parseCollectionDatesData(
    String collectionDatesString) {
  Map<String, dynamic> data = jsonDecode(collectionDatesString);

  Map<String, List<String>> collectionDates = {};

  data.forEach((key, value) {
    collectionDates[key] = List<String>.from(value);
  });

  return collectionDates;
}