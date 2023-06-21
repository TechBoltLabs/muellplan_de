// lib/widgets/homepage/location_and_category_settings.dart

import 'package:flutter/material.dart';


import 'location_settings.dart';
import 'category_settings.dart';
// TODO: import the dropdown button widget for the location/street getters/fetchers

class HomePageLocationAndCategorySettings extends StatelessWidget {
  const HomePageLocationAndCategorySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      // location settings and category selection
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        HomePageLocationSettings(),
        HomePageCategorySelection(),
      ],
    );
  }
}


