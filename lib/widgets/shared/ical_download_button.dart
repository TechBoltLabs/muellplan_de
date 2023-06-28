// lib/widgets/shared/ical_download_button.dart

// import libraries
import 'package:flutter/material.dart';
import 'package:muellplan_de/widgets/shared/customInputDialog.dart';

// import local files
import '../../constants/constants_barrel.dart';
import '../../notifiers/map_and_location_notifier.dart';


class ICalDownloadButton extends StatelessWidget {
  const ICalDownloadButton({super.key, required this.constraints, required this.notifier});

  final BoxConstraints constraints;
  final MapAndLocationNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: constraints.maxWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black, width: 0.6),
            ),
          ),
          onPressed: () {
            // TODO: implement buttonPress on iCal

            // show dialog 'button not implemented yet'
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //       backgroundColor: Colors.amberAccent,
            //       content: Text(
            //         'Dieser Button ist noch nicht implementiert! Es folgt in Kürze...',
            //         style: TextStyle(
            //           color: Colors.black,
            //         ),)),
            // );
            // FIXME: dialog is shown even if only location is selected
            if (notifier.selectedLocation.trim().isEmpty || notifier.selectedStreet.trim().isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bitte wählen Sie zuerst einen Ort und eine Straße aus!"),
                  backgroundColor: Colors.red,
                ),
              );
            } else{
              showCustomDialog(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'iCal',
              style: TextStyle(
                fontSize: fontSizeIncreased,
                fontFamily: fontFamilyDefault,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
