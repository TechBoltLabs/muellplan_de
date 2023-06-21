// lib/widgets/homepage/future_dates.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';
import '../../services/services_barrel.dart';
import '../shared/shared_barrel.dart';

class HomePageFutureDates extends StatefulWidget {
  const HomePageFutureDates({super.key});

  @override
  State<HomePageFutureDates> createState() => _HomePageFutureDatesState();
}

class _HomePageFutureDatesState extends State<HomePageFutureDates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapAndLocationNotifier>(
      builder: (context, mapAndLocationNotifier, child) {
        int selectedTimeSpan = mapAndLocationNotifier.selectedTimeSpanIndex;
        int numberOfDaysForFutureDates =
            mapAndLocationNotifier.numberOfDaysForFutureDates;
        // List<List<String>> futureDates = await _getFutureDates(
        //     notifier: mapAndLocationNotifier,
        //     location: mapAndLocationNotifier.selectedLocation,
        //     street: mapAndLocationNotifier.selectedStreet,
        //     numberOfDaysForFutureDates: numberOfDaysForFutureDates);
        return FutureBuilder<List<List<String>>>(
            future: _getFutureDates(
                notifier: mapAndLocationNotifier,
                location: mapAndLocationNotifier.selectedLocation,
                street: mapAndLocationNotifier.selectedStreet,
                numberOfDaysForFutureDates: numberOfDaysForFutureDates),
            builder: (context, snapshot) {
              if (!(snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData)) {
                return const Center(child: CircularProgressIndicator());
              } else{
                List<List<String>> futureDates = snapshot.data!;
                return LayoutBuilder(builder: (context, constraints) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        // width: MediaQuery.of(context).size.width - 232,
                        width: constraints.maxWidth - 32,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.45)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (MediaQuery.of(context).size.width >
                                          770)
                                        Row(
                                          children: [
                                            const Text(
                                              'Alle Termine innerhalb des Zeitraums',
                                              style: TextStyle(
                                                  fontSize: fontSizeIncreased,
                                                  fontFamily:
                                                      fontFamilyDefault),
                                            ),
                                            Container(
                                              decoration:
                                                  muellplanAPPCustomBorderDecoration(),
                                              height: 30,
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value:
                                                      timeSpansForFutureDates[
                                                          selectedTimeSpan],
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    mapAndLocationNotifier
                                                        .updateTimeSpanValue(
                                                            timeSpansForFutureDates
                                                                .indexOf(
                                                                    newValue!));
                                                  },
                                                  items: timeSpansForFutureDates
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                fontSizeDefault,
                                                            fontFamily:
                                                                fontFamilyDefault),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              'ab heute:',
                                              style: TextStyle(
                                                  fontSize: fontSizeIncreased,
                                                  fontFamily:
                                                      fontFamilyDefault),
                                            ),
                                          ],
                                        ),
                                      if (MediaQuery.of(context).size.width <=
                                              770 &&
                                          MediaQuery.of(context).size.width >
                                              630)
                                        Column(
                                          children: [
                                            const Text(
                                              'Weitere Termine innerhalb der nächsten',
                                              style: TextStyle(
                                                  fontSize: fontSizeIncreased,
                                                  fontFamily:
                                                      fontFamilyDefault),
                                            ),
                                            Container(
                                              decoration:
                                                  muellplanAPPCustomBorderDecoration(),
                                              height: 30,
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value:
                                                      timeSpansForFutureDates[
                                                          selectedTimeSpan],
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    mapAndLocationNotifier
                                                        .updateTimeSpanValue(
                                                            timeSpansForFutureDates
                                                                .indexOf(
                                                                    newValue!));
                                                  },
                                                  items: timeSpansForFutureDates
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                fontSizeDefault,
                                                            fontFamily:
                                                                fontFamilyDefault),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (MediaQuery.of(context).size.width <=
                                          630)
                                        Column(
                                          children: [
                                            const Text(
                                              'Weitere Termine',
                                              style: TextStyle(
                                                  fontSize: fontSizeIncreased,
                                                  fontFamily:
                                                      fontFamilyDefault),
                                            ),
                                            const Text(
                                              'innerhalb der nächsten',
                                              style: TextStyle(
                                                  fontSize: fontSizeIncreased,
                                                  fontFamily:
                                                      fontFamilyDefault),
                                            ),
                                            Container(
                                              decoration:
                                                  muellplanAPPCustomBorderDecoration(),
                                              height: 30,
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value:
                                                      timeSpansForFutureDates[
                                                          selectedTimeSpan],
                                                  icon: const Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    mapAndLocationNotifier
                                                        .updateTimeSpanValue(
                                                            timeSpansForFutureDates
                                                                .indexOf(
                                                                    newValue!));
                                                  },
                                                  items: timeSpansForFutureDates
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                            fontSize:
                                                                fontSizeDefault,
                                                            fontFamily:
                                                                fontFamilyDefault),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),

                                    // TODO: add a scrollbar if the list is too long
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        muellplanAPPCustomBoxShadow(),
                                      ],
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Text("$numberOfDaysForFutureDates"),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              // create as many rows as the function returns dates
                                              for (int i = 0;
                                                  i < futureDates.length;
                                                  i++)
                                                Container(
                                                  // one row
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5.0),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.grey.withOpacity(i % 2 == 0 ? 0.4 : 0),
                                                    color: i % 2 == 0
                                                        ? const Color(
                                                            0xffced4da)
                                                        : Colors.transparent,
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 0.2,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  futureDates[i]
                                                                      [0],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  border: Border
                                                                      .symmetric(
                                                            vertical:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 0.6,
                                                            ),
                                                          )),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    futureDates[
                                                                        i][1],
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  futureDates[i]
                                                                      [2],
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
              }
            });
      },
    );
  }
}

Future<List<List<String>>> _getFutureDates(
    {required MapAndLocationNotifier notifier,
    required String location,
    required String street,
    required int numberOfDaysForFutureDates,
    bool useWeekdayShortForms = false}) async {
  // map to temporarily store the fetched collection dates
  Map<String, List<String>> dates;
  // list to store the dates which the user is interested in
  List<List<String>> unorderedDates = [];
  // list to store the same dates but sort it first
  List<List<String>> futureDates = [];

  // variable for storing the last possible date,
  // that should be displayed in the future dates section
  String latestDayToShowDates;
  // variable to store the date converted to the european standard
  String dateEuropean;

  // // variable to skip the entries which are already displayed above the future dates section
  // int skipEntriesAmount = 1 + numberOfUpcomingDatesInCards;

  if (location != '' && street != '') {
    if (notifier.fetchedCollectionDates.isEmpty) {
      await fetchCollectionDates(notifier, location, street);
    }
    dates = notifier.fetchedCollectionDates;

    latestDayToShowDates = DateTime.now()
        .add(Duration(days: numberOfDaysForFutureDates))
        .toString();
    for (var categoryLabel in dates.keys) {
      String litterCategory =
          getKeyFromValue(map: headingsForLabelsMap, value: categoryLabel);
      if (notifier.checkedCategories[litterCategory] != null &&
          notifier.checkedCategories[litterCategory]!) {
        int i = 0;

        while (i < dates[categoryLabel]!.length &&
            dates[categoryLabel]![i].compareTo(latestDayToShowDates) <= 0) {
          String weekday = getWeekDay(
              date: dates[categoryLabel]![i],
              useShortForm: useWeekdayShortForms);

          List<String> dateEntry = [
            weekday,
            dates[categoryLabel]![i],
            categoryLabel
          ];
          unorderedDates.add(dateEntry);
          i++;
        }
      }
    }
    unorderedDates.sort((a, b) {
      DateTime dateA = DateTime.parse(a[1]);
      DateTime dateB = DateTime.parse(b[1]);
      return dateA.compareTo(dateB);
    });

    for (var listEntry in unorderedDates) {
      dateEuropean = getEuropeanDate(dateString: listEntry[1]);
      List<String> newListEntry = [listEntry[0], dateEuropean, listEntry[2]];
      futureDates.add(newListEntry);
    }
  }

  return futureDates.isNotEmpty
      ? futureDates
      : [
          ['-', '-', '-']
        ];
}
