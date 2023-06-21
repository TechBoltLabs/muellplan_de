// lib/widgets/homepage/upcoming_dates.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';
import '../../services/aggregation/date_and_time_information.dart';
import '../../services/api/api_barrel.dart';

// FIXME: show placeholder if no category is selected
class HomePageUpcomingDates extends StatefulWidget {
  const HomePageUpcomingDates({super.key});

  @override
  State<HomePageUpcomingDates> createState() => _HomePageUpcomingDatesState();
}

class _HomePageUpcomingDatesState extends State<HomePageUpcomingDates> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MapAndLocationNotifier>(
      builder: (context, mapAndLocationNotifier, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0, left: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nächste Termine:",
                          style: TextStyle(
                              fontSize: fontSizeIncreased,
                              fontFamily: fontFamilyDefault),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // the 'key' values are needed to be correctly handled as different widgets by flutter
                      if (mapAndLocationNotifier
                              .checkedCategories['residual'] ??
                          true)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'residual',
                          key: ValueKey('residual'),
                        ),
                      if (mapAndLocationNotifier
                              .checkedCategories['recycling'] ??
                          true)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'recycling',
                          key: ValueKey('recycling'),
                        ),
                      if (mapAndLocationNotifier.checkedCategories['paper'] ??
                          true)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'paper',
                          key: ValueKey('paper'),
                        ),
                      if (mapAndLocationNotifier.checkedCategories['bio'] ??
                          true)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'bio',
                          key: ValueKey('bio'),
                        ),
                      if (mapAndLocationNotifier
                              .checkedCategories['residual_container'] ??
                          false)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'residual_container',
                          key: ValueKey('residual_container'),
                        ),
                      if (mapAndLocationNotifier.nothingChecked())
                        // FIXME: show placeholder if no category is selected (even if location is set)
                        const MuellplanAPPNextDateCardContainer(
                          litterCategory: 'nothingChecked',
                          key: ValueKey('nothingChecked'),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MuellplanAPPNextDateCardContainer extends StatefulWidget {
  final String litterCategory;

  const MuellplanAPPNextDateCardContainer(
      {Key? key, required this.litterCategory})
      : super(key: key);

  @override
  State<MuellplanAPPNextDateCardContainer> createState() =>
      _MuellplanAPPNextDateCardContainerState();
}

class _MuellplanAPPNextDateCardContainerState
    extends State<MuellplanAPPNextDateCardContainer> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                MuellplanAPPNextDateCard(
                  litterCategory: widget.litterCategory,
                  key: ValueKey(widget.key),
                ),
              ],
            ),
            if (widget.litterCategory != 'nothingChecked')
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: MuellplanAPPNextDateCardContainerAdditionalInformation(
                  litterCategory: widget.litterCategory,
                  key: ValueKey(widget.key),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MuellplanAPPNextDateCard extends StatefulWidget {
  final String litterCategory;

  const MuellplanAPPNextDateCard({Key? key, required this.litterCategory})
      : super(key: key);

  @override
  State<MuellplanAPPNextDateCard> createState() =>
      _MuellplanAPPNextDateCardState();
}

class _MuellplanAPPNextDateCardState extends State<MuellplanAPPNextDateCard> {
  late String _litterCategory;
  late String _heading;
  late List<Color> _boxColors;
  late Color _boxColor;
  late Color _textColor;
  late List<List<String>> _date;

  @override
  void initState() {
    super.initState();
    _litterCategory = widget.litterCategory;
    _heading = getHeadingForLabel(_litterCategory, 'Fehler');
    // _heading = _getNextDateCardHeading(_litterCategory);
    _boxColors = _getNextDateCardColor(_litterCategory);
    _boxColor = _boxColors[0];
    _textColor = _boxColors[1];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // color: _boxColor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _boxColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 4,
              blurRadius: 4,
              offset: const Offset(4, 4), // changes position of shadow
            ),
          ],
        ),
        child: SizedBox(
          height: 100,
          width: 200,
          child: Consumer<MapAndLocationNotifier>(
            builder: (context, mapAndLocationNotifier, child) {
              // _date = _getNextDateCardDates(
              //     notifier: mapAndLocationNotifier,
              //     litterCategory: _litterCategory,
              //     location: mapAndLocationNotifier.selectedLocation,
              //     street: mapAndLocationNotifier.selectedStreet);

              return FutureBuilder<List<List<String>>>(
                  future: _getNextDateCardDates(
                      notifier: mapAndLocationNotifier,
                      litterCategory: _litterCategory,
                      location: mapAndLocationNotifier.selectedLocation,
                      street: mapAndLocationNotifier.selectedStreet),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      _date = snapshot.data!;
                    } else if (snapshot.hasError) {
                      _date = [
                        ['-', '-']
                      ];
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _heading,
                          style: TextStyle(
                            fontSize: fontSizeDefault + 2,
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                          ),
                        ),
                        if (_litterCategory != 'nothingChecked')
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _date[0][0],
                                  style: TextStyle(
                                    fontSize: fontSizeDefault,
                                    color: _textColor,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  _date[0][1],
                                  style: TextStyle(
                                    fontSize: fontSizeDefault,
                                    color: _textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}

class MuellplanAPPNextDateCardContainerAdditionalInformation
    extends StatefulWidget {
  final String litterCategory;

  const MuellplanAPPNextDateCardContainerAdditionalInformation(
      {Key? key, required this.litterCategory})
      : super(key: key);

  @override
  State<MuellplanAPPNextDateCardContainerAdditionalInformation> createState() =>
      _MuellplanAPPNextDateCardContainerAdditionalInformationState();
}

class _MuellplanAPPNextDateCardContainerAdditionalInformationState
    extends State<MuellplanAPPNextDateCardContainerAdditionalInformation> {
  late String _litterCategory;
  late List<List<String>> _dates;
  late String _location;
  late String _street;

  @override
  void initState() {
    super.initState();
    _litterCategory = widget.litterCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4.0, left: 4.0, top: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 2,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Consumer<MapAndLocationNotifier>(
          builder: (context, mapAndLocationNotifier, child) {
        _location = mapAndLocationNotifier.selectedLocation;
        _street = mapAndLocationNotifier.selectedStreet;
        // _dates = _getNextDateCardDates(
        //   notifier: mapAndLocationNotifier,
        //   litterCategory: _litterCategory,
        //   location: _location,
        //   street: _street,
        //   useWeekdayShortForms: false,
        //   skipCollectionsAmount: 1,
        //   getCollectionsAmount: numberOfUpcomingDatesInCards,
        // );
        return FutureBuilder<List<List<String>>>(
            future: _getNextDateCardDates(
              notifier: mapAndLocationNotifier,
              litterCategory: _litterCategory,
              location: _location,
              street: _street,
              useWeekdayShortForms: false,
              skipCollectionsAmount: 1,
              getCollectionsAmount: numberOfUpcomingDatesInCards,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                _dates = snapshot.data!;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          // create as many rows as the function returns dates
                          for (int i = 0; i < _dates.length; i++)
                            Container(
                              // one row
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              decoration: BoxDecoration(
                                // color: Colors.grey.withOpacity(i % 2 == 0 ? 0.4 : 0),
                                color: i % 2 == 0
                                    ? const Color(0xffced4da)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    _dates[i][0],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 10,
                                    height: fontSizeDefault.toDouble(),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          width: 1.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _dates[i][1],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Text('');
              }
            });
      }),
    );
  }
}

// TODO: put this method into the nextDateCard Widget Class file
Future<List<List<String>>> _getNextDateCardDates(
    {required MapAndLocationNotifier notifier,
    required String litterCategory,
    required String location,
    required String street,
    bool useWeekdayShortForms = false,
    int skipCollectionsAmount = 0,
    int getCollectionsAmount = 1}) async {
  List<String> dates = [];
  List<List<String>> collectionDays = [];

  if (location != '' && street != '') {
    if (notifier
            .fetchedCollectionDates[getHeadingForLabel(litterCategory, '')] ==
        null) {
      await fetchCollectionDates(
        notifier,
        location,
        street,
      );
    }
    dates = notifier
        .fetchedCollectionDates[getHeadingForLabel(litterCategory, '')]!;

    if (skipCollectionsAmount + getCollectionsAmount > dates.length) {
      getCollectionsAmount = dates.length - skipCollectionsAmount;
    }

    for (int i = skipCollectionsAmount;
        i < skipCollectionsAmount + getCollectionsAmount;
        i++) {
      String day = DateTime.parse(dates[i]).day.toString();
      String month = DateTime.parse(dates[i]).month.toString();
      String dateEuropean = '$day.$month.';

      String weekday =
          getWeekDay(date: dates[i], useShortForm: useWeekdayShortForms);

      collectionDays.add([weekday, dateEuropean]);
    }
  }

  return collectionDays.isNotEmpty
      ? collectionDays
      : [
          ['-', '-']
        ];
}

// TODO: put this method into the nextDateCard Widget Class file
List<Color> _getNextDateCardColor(String litterCategory) {
  Color boxColor;
  Color textColor;

  switch (litterCategory) {
    case 'residual':
      boxColor = Colors.black;
      textColor = Colors.white;
      break;
    case 'recycling':
      boxColor = const Color(0xFFfab005);
      textColor = Colors.black;
      break;
    case 'paper':
      boxColor = const Color(0xFF40c057);
      textColor = Colors.black;
      break;
    case 'bio':
      // boxColor = Color(0xff7a6263);
      boxColor = const Color(0xff946846);
      textColor = Colors.white;
      break;
    case 'residual_container':
      boxColor = Colors.black.withOpacity(0.7);
      textColor = Colors.white;
      break;
    default:
      boxColor = Colors.grey;
      textColor = Colors.black;
  }

  return [boxColor, textColor];
}
