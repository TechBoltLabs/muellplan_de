// /lib/widgets/shared/customInputDialog.dart

// import libraries
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import local files
import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';
import '../../services/api/ical_service.dart';

class CustomAlertDialog extends StatefulWidget {
  final TextEditingController daysBeforeController;
  final TimeOfDay selectedTime;

  const CustomAlertDialog({super.key, required this.daysBeforeController, required this.selectedTime});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Einstellungen zu den Kalendereinträgen'),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black, width: 0.6),
      ),
      content: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction, // validate when the user interacts
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Wie viele Tage vor dem Termin möchten Sie erinnert werden?"),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.35,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: widget.daysBeforeController,
                        validator: (value) {
                          int? number = int.tryParse(value ?? '');
                          if (number == null) {
                            return "Bitte geben Sie eine Zahl ein!";
                          }
                          return null; // Return null if the value is valid
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          labelText: "Anzahl der Tage",
                          labelStyle: TextStyle(
                            fontSize: fontSizeDefault,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Um wie viel Uhr soll die Benachrichtigung erscheinen?"),
              ),
              Row(
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.35,
                      child: ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? newTime = await selectTime(context, _selectedTime);
                          setState(() {
                            _selectedTime = newTime;
                          });
                        },
                        child: const Text(
                          'Zeit auswählen',
                          style: TextStyle(
                            fontSize: fontSizeDefault,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.35,
                      child: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        ,
      ),
      actions: <Widget>[
        Consumer<MapAndLocationNotifier>(
          builder: (context, notifier, child) {
            return TextButton(
                child: const Text(
                  'Anfordern',
                  style: TextStyle(
                    fontSize: fontSizeDefault,
                  ),
                ),
              onPressed: () {
                  if(widget.daysBeforeController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bitte wählen Sie eine Anzahl an Tagen aus!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  } else {
                    String daysBefore = widget.daysBeforeController.text;
                    String time = _selectedTime.format(context);
                    List<String> categories = notifier.checkedCategories.entries
                    .where((entry) => entry.value)
                    .map((e) => e.key)
                    .toList();
                    String location = notifier.fetchedLocations[notifier.selectedLocation]!;
                    String street = notifier.fetchedStreets[notifier.selectedStreet]!;

                    String informationHash = createInformationHashForICal(location, street, categories, daysBefore, time);
                    if(kIsWeb){
                      String url = "$backendHost/download/ical/$informationHash";
                      AnchorElement anchorElement = AnchorElement(href: url);
                      anchorElement.download = "muellplan.ics";
                      anchorElement.click();
                    }
                  }

                  Navigator.of(context).pop();
                  // TODO: implement the logic to send the data to the backend
              },
            );
          }
        ),
        TextButton(
          child: const Text('Schließen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

  }
}


void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController daysBeforeController = TextEditingController();
      TimeOfDay selectedTime = TimeOfDay.now();


      // Return your dialog
      return CustomAlertDialog(daysBeforeController: daysBeforeController, selectedTime: selectedTime);
    },
  );
}

Future<TimeOfDay> selectTime(BuildContext context,TimeOfDay selectedTime) async{
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: selectedTime,
  );
  if (picked != null) {
    selectedTime = picked;
  }

  return selectedTime;
}