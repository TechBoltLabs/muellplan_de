// lib/notifiers/map_and_location_notifier.dart

import 'dart:html' as html;

// import libraries
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import local files
import '../constants/constants_barrel.dart';
import '../services/services_barrel.dart';

// the change notifier for the map and location
class MapAndLocationNotifier extends ChangeNotifier {
  // initialize variables
  // general
  String currentYear = DateTime.now().year.toString();
  late Map<String, String> fetchedLocations  = initialPlaceholderLocations;
  late Map<String, String> fetchedStreets = initialPlaceholderStreets;
  late Map<String, List<String>> fetchedCollectionDates =
      initialPlaceholderCollectionDates;

  // location settings' variables
  Map<String, bool> checkedCategories = {};
  String selectedLocation = '';
  String selectedStreet = '';
  bool streetsInitialized = false;

  // future dates' variables
  int selectedTimeSpanIndex = 1;
  late int numberOfDaysForFutureDates;

  MapAndLocationNotifier(Map<String, bool> buildTimeCheckedCategories) {
    checkedCategories = buildTimeCheckedCategories;
    numberOfDaysForFutureDates = getNumberOfDaysForFutureDates(
        selectedTimeSpanIndex: selectedTimeSpanIndex);
    fetchedCollectionDates = initialPlaceholderCollectionDates;
    // getLocationAndStreet();
  }

  void updateCheckboxValue(String key, bool value) {
    checkedCategories[key] = value;
    notifyListeners();
  }

  void updateLocationValue(String value) {
    invalidateStreets();
    updateStreetValue('');
    selectedLocation = value;
    setCurrentLocationInURL();
    notifyListeners();
  }

  void updateStreetValue(String value) {
    invalidateCollectionDates();
    selectedStreet = value;
    setCurrentStreetInURL();
    notifyListeners();
  }

  void updateTimeSpanValue(int value) {
    selectedTimeSpanIndex = value;
    numberOfDaysForFutureDates = getNumberOfDaysForFutureDates(
        selectedTimeSpanIndex: selectedTimeSpanIndex);
    notifyListeners();
  }

  // FIXME: if data is selected, the nothingChecked seems not to work or isn't used properly
  bool nothingChecked() {
    bool nothingChecked = true;
    checkedCategories.forEach((key, value) {
      if (value) {
        nothingChecked = false;
      }
    });
    return nothingChecked;
  }

  void setLocations(Map<String, String> locations) {
    // fetchedLocations = locations.isNotEmpty ? locations : fetchedLocations;
    fetchedLocations = locations;
    notifyListeners();
  }

  void setStreets(Map<String, String> streets) {
    fetchedStreets = streets;
    if (!streetsInitialized) {
      streetsInitialized = true;
    }
    notifyListeners();
  }

  void setCollectionDates(Map<String, List<String>> collectionDates) {
    fetchedCollectionDates = collectionDates;
    notifyListeners();
  }

  void invalidateStreets() {
    invalidateCollectionDates();
    fetchedStreets = {};
    streetsInitialized = false;
  }

  void invalidateCollectionDates() {
    fetchedCollectionDates = initialPlaceholderCollectionDates;
  }

  // void setCurrentLocationAndStreet(/*String location, String street*/) {
  //   var url = Uri.parse(html.window.location.href)
  //       .replace(queryParameters: <String, String>{
  //     'location': selectedLocation,
  //     'street': selectedStreet,
  //   }).toString();
  //
  //   html.window.history.pushState(null, 'New Page Title', url);
  // }

  //TODO: delete me
  // void getLocationAndStreet() {
  //   var url = Uri.parse(html.window.location.href);
  //
  //   String location = url.queryParameters['location'] ?? '';
  //   String street = url.queryParameters['street'] ?? '';
  //
  //   print('Location: $location, Street: $street');
  // }

  void setCurrentLocationInURL() {
    Uri currentUri = Uri.parse(html.window.location.href);
    String newURL;
    if (selectedLocation == '') {
      newURL = Uri(
              scheme: currentUri.scheme,
              host: currentUri.host,
              port: currentUri.port,
              path: currentUri.path)
          .toString();
    } else {
      newURL = Uri.parse(html.window.location.href)
          .replace(queryParameters: <String, String>{
        'location': selectedLocation,
      }).toString();
    }

    // var url = Uri.parse(html.window.location.href)
    //     .replace(queryParameters: <String, String>{
    //   'location': selectedLocation,
    // });

    // var uri = Uri.parse(html.window.location.href);
    // Map<String,String> queryParameters = {};
    // if(selectedLocation != '') {
    //   queryParameters['location'] = selectedLocation;
    // }
    // var url = uri.replace(queryParameters: queryParameters).toString();

    // FIXME: change the title argument of this function call
    html.window.history.pushState(null, 'New Page Title', newURL);
  }

  void setCurrentStreetInURL() {
    Uri currentUri = Uri.parse(html.window.location.href);
    String newURL;

    if (selectedStreet == '' ||
        selectedStreet == 'wählen Sie erst einen Ort aus!') {
      newURL = Uri(
          scheme: currentUri.scheme,
          host: currentUri.host,
          port: currentUri.port,
          path: currentUri.path,
          queryParameters: <String, String>{
            'location': selectedLocation,
          }).toString();
      // FIXME: change the title argument of this function call
      html.window.history.pushState(null, 'New Page Title', newURL);
      return;
    } else {
      newURL = currentUri.replace(queryParameters: <String, String>{
        'location': selectedLocation,
        'street': selectedStreet,
      }).toString();
    }

    // var url = Uri.parse(html.window.location.href)
    //     .replace(queryParameters: <String, String>{
    //   'location': selectedLocation,
    //   'street': selectedStreet,
    // }).toString();

    // FIXME: change the title argument of this function call
    html.window.history.pushState(null, 'New Page Title', newURL);
  }

  // TODO: handle malformed locations in the URL
  Future<void> getLocationFromURLIfExists() async{
    var url = Uri.parse(html.window.location.href);
    String location = url.queryParameters['location'] ?? '';
    selectedLocation = location;
    if (location != '') {
      await fetchStreets(this, location);
    }
    notifyListeners();
  }

  // TODO: handle malformed streets in the URL
  Future<void> getStreetFromURLIfExists() async {
    var url = Uri.parse(html.window.location.href);
    String street = url.queryParameters['street'] ?? '';
    selectedStreet = street;
    if (street != '') {
      await fetchCollectionDates(this, selectedLocation, street);
    }
    notifyListeners();
  }

  // creates a string of all currently selected categories concatenated and separated by a comma
  String getSelectedCategoriesAsString() {
    List<String> selectedCategories = [];
    checkedCategories.forEach((key, value) {
      if (value) {
        selectedCategories.add(key);
      }
    });
    return selectedCategories.join(',');
  }
}
