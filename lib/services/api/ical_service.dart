// lib/services/api/ical_service.dart

import 'dart:convert';


// this packs all information needed to generate the ical file into a json object
// then encodes it in base64 and sends it to the backend
//
// the json object has the following structure:
// {
//   "locationCode" : "locationCode",
//   "streetCode" : "streetCode",
//   "categories" : ["category1", "category2", "category3"]
//   "daysBefore" : "daysBefore",
//   "notificationTime" : "notificationTime"
// }
// TODO: add current timestamp to the json object to invalidate the link after a certain time (e.g. 2 minutes)
String createInformationHashForICal(String locationCode, String streetCode, List<String> categories, String daysBefore, String notificationTime) {
  Map<String,dynamic> mapToHash  = {
    "locationCode":locationCode,
    "streetCode":streetCode,
    "categories":categories,
    "daysBefore":daysBefore,
    "notificationTime":notificationTime
  };

  String informationToHash = json.encode(mapToHash);
  String encodedInformation = base64.encode(utf8.encode(informationToHash));
  return encodedInformation;
}