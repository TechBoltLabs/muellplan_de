// lib/services/general.dart

// this method gets a map and a value string
// and returns the right key for accessing the value
String getKeyFromValue({required Map map, required String value}) {
// for every entry in the map
  for (var entry in map.entries) {
    // check, if the value of the entry equals to the provided value
    if (entry.value == value) {
      // if so, return the key for that value
      return entry.key;
    }
  }
  // if no match could be found in the map, return an empty string
  return '';
}


