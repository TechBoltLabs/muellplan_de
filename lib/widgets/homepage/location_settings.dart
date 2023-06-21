// lib/widgets/homepage/location_settings.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';
import '../../services/api/api_barrel.dart';
import '../shared/shared_barrel.dart';

class HomePageLocationSettings extends StatefulWidget {
  const HomePageLocationSettings({super.key});

  @override
  _HomePageLocationSettingsState createState() =>
      _HomePageLocationSettingsState();

}

class _HomePageLocationSettingsState extends State<HomePageLocationSettings> {
  String _location = '';
  String _street = '';

  late MapAndLocationNotifier _mapAndLocationNotifier;

  @override
  void initState() {
    super.initState();
    // callback method to be called after the widget is rendered
    // this is necessary to get the location and street from the URL
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      _mapAndLocationNotifier = Provider.of<MapAndLocationNotifier>(context, listen: false);
      await _mapAndLocationNotifier.getLocationFromURLIfExists();
      await _mapAndLocationNotifier.getStreetFromURLIfExists();
      _location = _mapAndLocationNotifier.selectedLocation;
      _street = _mapAndLocationNotifier.selectedStreet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapAndLocationNotifier>(
        builder: (context, mapAndLocationNotifier, child) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 160, maxWidth: MediaQuery.of(context).size.width / 4),
        child: Column(
          // location settings
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Row(
              // location label
              children: [
                Text(
                  'Ort:',
                  style: TextStyle(fontSize: fontSizeDefault),
                ),
              ],
            ), // enter location
            Row(children: [
              Expanded(
                  child: Container(
                decoration: muellplanAPPCustomBorderDecoration(),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _location,
                    icon: const Icon(Icons.arrow_drop_down, size: 40),
                    onChanged: (String? newLocation) async {
                      // mapAndLocationNotifier.updateStreetValue('');

                      if(newLocation != null){
                          mapAndLocationNotifier
                              .updateLocationValue(newLocation);
                          // mapAndLocationNotifier.setCurrentLocationInURL();
                          setState(() {
                            _street = '';
                            _location = newLocation;
                            if (_location != '') {}
                          });
                          if(newLocation.isNotEmpty){await fetchStreets(
                              mapAndLocationNotifier, newLocation);
                        }
                      }
                    },
                    items: _getLocationsList(mapAndLocationNotifier)
                        .map<DropdownMenuItem<String>>((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 35.0),
                          child: Text(
                            location,
                            style: const TextStyle(fontSize: fontSizeDefault),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ))
            ]),
            const Row(
              // street label
              children: [
                Text(
                  'Straße:',
                  style: TextStyle(fontSize: fontSizeDefault),
                ),
              ],
            ),
            Row(
              // enter street
              children: [
                Expanded(
                    child: Container(
                  decoration: muellplanAPPCustomBorderDecoration(),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _street,
                      icon: const Icon(Icons.arrow_drop_down, size: 40),
                      onChanged: (String? newStreet) async {
                        String location = mapAndLocationNotifier.selectedLocation;
                        if(location.isNotEmpty && newStreet != null){
                          mapAndLocationNotifier.updateStreetValue(newStreet);
                          // mapAndLocationNotifier.setCurrentStreetInURL();
                          setState(() {
                            _street = newStreet;
                          });
                          // has to be called after the street has been updated
                            if(newStreet.isNotEmpty)  {
                            await fetchCollectionDates(
                                mapAndLocationNotifier, _location, _street);
                          } else{
                            mapAndLocationNotifier.invalidateCollectionDates();
                            }
                        }
                      },
                      items: // replace this placeholder with data from database
                          _getStreetsList(mapAndLocationNotifier, _location)
                              .map<DropdownMenuItem<String>>((String street) {
                        return DropdownMenuItem<String>(
                          value: street,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 35.0),
                            child: Text(
                              street,
                              style: const TextStyle(fontSize: fontSizeDefault),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      );
    });
  }
}

// TODO: put this method into the Dropdown-Button Class file
List<String> _getLocationsList(MapAndLocationNotifier notifier) {
  List<String> locations = [];

  locations.add(''); // empty string for the first item in the dropdown menu

  notifier.fetchedLocations.forEach((key, value) {
    locations.add(key);
  });

  return locations;
}

// TODO: put this method into the Dropdown-Button Class file
Iterable<String> _getStreetsList(
    MapAndLocationNotifier notifier, String location) {
  List<String> streets = [];

  streets.add(''); // empty string for the first item in the dropdown menu
  if (notifier.streetsInitialized) {
    notifier.fetchedStreets.forEach((key, value) {
      streets.add(key);
    });
  }

  return streets;
}
