// lib/widgets/homepage.dart

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

import '../../drawer.dart';
import '../my_appbar.dart';
import 'location_and_category_settings.dart';
import 'upcoming_dates.dart';
import 'future_dates.dart';
import 'download_overview_area.dart';


// the homepage widget of the app
class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      drawer: const MuellplanAPPDrawer(),
      body: ListView(children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: 30.0,
              horizontal: MediaQuery.of(context).size.width > 1200 ? 100 : 60),
          child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
            return Column(
              // main column
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const HomePageLocationAndCategorySettings(),
                const Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: HomePageUpcomingDates(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Dash(
                    direction: Axis.horizontal,
                    // length: MediaQuery.of(context).size.width - 232,
                    length: constraints.maxWidth - 32,
                    dashLength: 10,
                    dashColor: Colors.grey,
                  ),
                ),
                const HomePageFutureDates(),
                const HomePageDownloadOverviewArea(),
              ],
            );
          }),
        )
      ]),
    );
  }
}