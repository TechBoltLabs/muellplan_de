// lib/services/api/location_service.dart

import 'dart:convert';
import 'package:muellplan_de/services/api/general.dart';
import 'package:muellplan_de/constants/constants_barrel.dart';
import 'package:muellplan_de/notifiers/map_and_location_notifier.dart';

Future<void> fetchLocations(MapAndLocationNotifier notifier) async {
  String locationsURL = "$backendHost/locations";

  String locationsString = await fetchDocument(locationsURL);

  Map<String, String> locations = parseLocationData(locationsString);

  notifier.setLocations(locations);
}

Map<String, String> parseLocationData(String locationsString) {
  List data = jsonDecode(locationsString);
  Map<String, String> locationsMap = {};

  for (var location in data) {
    locationsMap[location[0]] = location[1];
  }

  return locationsMap;
}