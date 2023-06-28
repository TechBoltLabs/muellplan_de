// lib/widgets/mail-subscription/mail-subscription.dart

// import libraries
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import local files
import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';
import '../../services/api/api_barrel.dart';
import '../../widgets/shared/shared_barrel.dart';
import '../../widgets/homepage/location_and_category_settings.dart';
import '../../drawer.dart';
import '../my_appbar.dart';

class MailSubscription extends StatefulWidget {
  const MailSubscription({Key? key}) : super(key: key);

  @override
  State<MailSubscription> createState() => _MailSubscriptionState();
}

class _MailSubscriptionState extends State<MailSubscription> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController daysController;
  late final TextEditingController timeController;
  late List<String> notificationDays;
  late List<String> notificationTimes;
  late String selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    emailController = TextEditingController();
    daysController = TextEditingController();
    timeController = TextEditingController();

    notificationDays = ['1', '2', '3', '4', '5', '6', '7'];
    notificationTimes = [
      '0:00',
      '1:00',
      '2:00',
      '3:00',
      '4:00',
      '5:00',
      '6:00',
      '7:00',
      '8:00',
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00'
    ];
    daysController.text = notificationDays[1];
    timeController.text = notificationTimes[16];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(title: "E-Mail Benachrichtigung"),
      drawer: const MuellplanAPPDrawer(),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 60),
        child: Column(
          children: <Widget>[
            const HomePageLocationAndCategorySettings(),
            Form(
              key: formKey,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 60.0, horizontal: 250),
                padding: const EdgeInsets.symmetric(
                    horizontal: 100.0, vertical: 30.0),
                // width: MediaQuery.of(context).size.width - 232,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.45)),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      muellplanAPPCustomBoxShadow(),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'E-Mail Benachrichtigung',
                          style: TextStyle(
                            fontSize: fontSizeIncreased,
                            fontFamily: fontFamilyDefault,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 80.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Vorname',
                            ),
                            validator: (value) {
                              // name validation
                              if (value == null || value.isEmpty) {
                                return 'Bitte geben Sie einen Namen ein';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-Mail',
                            ),
                            validator: (value) {
                              // TODO: improve email validation
                              // email validation
                              if (value == null || value.isEmpty) {
                                return 'Bitte geben Sie eine E-Mail Adresse ein';
                              } else if (!isValidEmail(value)) {
                                return 'Bitte geben Sie eine gültige E-Mail Adresse ein';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: daysController.text,
                          onChanged: (String? newValue) {
                            setState(() {
                              daysController.text = newValue!;
                            });
                          },
                          items: notificationDays.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text('$value Tag(e) vorher'),
                            );
                          }).toList(),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          child: const Text(
                            'um',
                            style: TextStyle(
                              fontSize: fontSizeDefault,
                              fontFamily: fontFamilyDefault,
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          value: timeController.text,
                          hint: const Text('Uhrzeit'),
                          onChanged: (String? newValue) {
                            setState(() {
                              timeController.text = newValue!;
                            });
                          },
                          items: notificationTimes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Consumer<MapAndLocationNotifier>(builder:
                              (context, mapAndLocationNotifier, child) {
                            return ElevatedButton(
                              onPressed: () {
                                // FIXME: ensure, that location and street are not null or empty
                                if (mapAndLocationNotifier
                                        .selectedLocation.isEmpty ||
                                    mapAndLocationNotifier
                                        .selectedStreet.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Bitte wählen Sie eine Straße und einen Ort aus')),
                                  );
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    String name = nameController.text;
                                    String email = emailController.text;
                                    String days = daysController.text;
                                    String time = timeController.text;
                                    // String location = getKeyFromValue(
                                    //     map: mapAndLocationNotifier
                                    //         .fetchedLocations,
                                    //     value: mapAndLocationNotifier
                                    //         .selectedLocation);
                                    // String street = getKeyFromValue(
                                    //     map: mapAndLocationNotifier
                                    //         .fetchedStreets,
                                    //     value: mapAndLocationNotifier
                                    //         .selectedStreet);
                                    String locationCode =
                                        mapAndLocationNotifier.fetchedLocations[
                                            mapAndLocationNotifier
                                                .selectedLocation]!;
                                    String streetCode = mapAndLocationNotifier
                                            .fetchedStreets[
                                        mapAndLocationNotifier.selectedStreet]!;
                                    String categoriesStr =
                                        mapAndLocationNotifier
                                            .getSelectedCategoriesAsString();

                                    // send mail
                                    subscribeToMail(
                                        name: name,
                                        email: email,
                                        daysBefore: days,
                                        time: time,
                                        locationCode: locationCode,
                                        streetCode: streetCode,
                                        categoriesStr: categoriesStr);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Colors.green,
                                          duration: Duration(seconds: 5),
                                          content: Text(
                                              'Anfrage gesendet...  -  Je nach E-Mail Anbieter kann es bis zu 1 Stunde dauern, bis Sie die Bestätigungsmail erhalten.')),
                                    );
                                  }
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 60),
                                child: Text('absenden'),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

bool isValidEmail(String input) {
  final RegExp regex =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9_%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$");

  return regex.hasMatch(input);
}
