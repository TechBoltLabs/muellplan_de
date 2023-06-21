// lib/constants/label_headings.dart

// this map stores information about categories (litter) and their headings
const Map<String, String> headingsForLabelsMap = {
  'residual': 'Restmüll',
  'recycling': 'Gelber Sack',
  'paper': 'Papier',
  'bio': 'Biomüll',
  'residual_container': 'Restmüll Container',
  'nothingChecked': 'Keine Kategorie ausgewählt',
  '': '---'
};

// this method gets an optional litter category and a required override label (kind of a fallback value)
// and returns the right label if it exists, otherwise return the override label
String getHeadingForLabel(String? litterCategory, String overrideLabel) {
  // check, if the category was provided and if there is an entry for that category in the headingsForLabelsMap
  return litterCategory != null && headingsForLabelsMap[litterCategory] != null
      // if so, return the existing label from the map
      ? headingsForLabelsMap[litterCategory]!
      // else return the override label (which acts as a default here)
      : overrideLabel;
}
