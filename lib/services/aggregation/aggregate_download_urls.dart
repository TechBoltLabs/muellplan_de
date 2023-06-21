// lib/services/aggregation/aggregate_download_urls.dart

import 'package:muellplan_de/notifiers/map_and_location_notifier.dart';

String getPDFDownloadURL(MapAndLocationNotifier notifier, String location, String street){
  String locationCode = notifier.fetchedLocations[location]!;
  String streetCode = notifier.fetchedStreets[street]!;
  String year = notifier.currentYear;

  String pdfDownloadURL = "https://www.heinz-entsorgung.de/wp-includes/heinz_forms/Abfuhrkalender/php/query.php?PDF=1&ORT=$locationCode&STRASSE=$streetCode&Jahr=$year";
  return pdfDownloadURL;
}