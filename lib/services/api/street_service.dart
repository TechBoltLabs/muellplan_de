// lib/services/api/street_service.dart

import 'dart:convert';
import 'package:muellplan_de/services/api/general.dart';
import 'package:muellplan_de/constants/constants_barrel.dart';
import 'package:muellplan_de/notifiers/map_and_location_notifier.dart';

Future<void> fetchStreets(
    MapAndLocationNotifier notifier, String location) async {

  // variable for building the request URL correctly
  String locationCode = notifier.fetchedLocations[location]!;

  // the request URL
  String streetsURL = "$backendHost/streets/$locationCode";

  String streetsString = await fetchDocument(streetsURL);
  Map<String, String> streets = parseStreetsData(streetsString);

  notifier.setStreets(streets);
}

Map<String, String> parseStreetsData(String streetsString) {
  List data = jsonDecode(streetsString);
  Map<String, String> streetsMap = {};

  for (var street in data) {
    streetsMap[street[0]] = street[1];
  }

  return streetsMap;
}