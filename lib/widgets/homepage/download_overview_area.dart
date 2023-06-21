// lib/widgets/homepage/download_overview_area.dart

// FIXME: WARNING: Don't use web-only libraries outside Flutter web plugin packages.

// TODO: implement download for mobile and for desktop

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../notifiers/map_and_location_notifier.dart';
import '../shared/shared_barrel.dart';

// the download buttons for collection dates overview and calendar
class HomePageDownloadOverviewArea extends StatelessWidget {
  const HomePageDownloadOverviewArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FIXME: size comparison doesn't make much sense (width > 750 ? and then width > 1200 ?)
    if (MediaQuery.of(context).size.width > 750) {
      return Container(
        width: MediaQuery.of(context).size.width > 1200
            ? MediaQuery.of(context).size.width / 3
            : MediaQuery.of(context).size.width / 2,
        margin: const EdgeInsets.only(top: 60),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        // TODO: use decoration widget for that (anti redundancy)
        decoration: muellplanAPPCustomBorderDecoration(),
        child: Consumer<MapAndLocationNotifier>(
            builder: (context, mapAndLocationNotifier, child) {
          return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DownloadAreaHeading(),
                PDFDownloadButton(
                    constraints: constraints, notifier: mapAndLocationNotifier),
                ICalDownloadButton(
                    constraints: constraints, notifier: mapAndLocationNotifier),
              ],
            );
          });
        }),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width > 1111
            ? MediaQuery.of(context).size.width / 3
            : MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width > 750 ? 127.2 : 175,
        margin: const EdgeInsets.only(top: 60),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: muellplanAPPCustomBorderDecoration(),
        child: Consumer<MapAndLocationNotifier>(
          builder: (context, mapAndLocationNotifier, child) {
            return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DownloadAreaHeading(),
                  PDFDownloadButton(constraints: constraints, notifier: mapAndLocationNotifier),
                  ICalDownloadButton(constraints: constraints, notifier: mapAndLocationNotifier),
                ],
              );
            });
          }
        ),
      );
    }
  }
}
