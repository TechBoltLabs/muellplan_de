// lib/constants/initial_data.dart

Map<String, bool> initialCheckedCategories = {
  'residual': true,
  'recycling': true,
  'paper': true,
  'bio': true,
  'residual_container': false
};

Map<String, List<String>> initialPlaceholderCollectionDates = {
'Biomüll': ['-'],
'Restmüll': ['-'],
'Papier': ['-'],
'Gelber Sack': ['-'],
'Restmüll Container': ['-']
};

Map<String, String> initialPlaceholderLocations = {
  '': 'Bitte wählen Sie eine Stadt aus'
};

Map<String,String> initialPlaceholderStreets = {
  '': 'Bitte wählen Sie eine Straße aus'
};