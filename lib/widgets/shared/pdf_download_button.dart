// lib/widgets/shared/pdf_download_button.dart

// import libraries
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import local files
import '../../notifiers/map_and_location_notifier.dart';
import '../../constants/constants_barrel.dart';
import '../../services/aggregation/aggregation_barrel.dart';

class PDFDownloadButton extends StatelessWidget {
  const PDFDownloadButton({super.key, required this.constraints, required this.notifier});
  
  final BoxConstraints constraints;
  final MapAndLocationNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: constraints.maxWidth,
        margin: const EdgeInsets.symmetric(horizontal: 10),
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
          onPressed: () async {
            // TODO: move redundant code to external element

            // FIXME: show message if location and/or street is not selected
            String url = getPDFDownloadURL(notifier,notifier.selectedLocation, notifier.selectedStreet);

            // this checks if the app is running on web
            if(kIsWeb){
              AnchorElement anchorElement = AnchorElement(href: url);
              anchorElement.download = url;
              anchorElement.click();
            } else{
              // TODO: implement download for mobile and for desktop
              print("download for mobile and desktop not implemented yet");
            }
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'PDF',
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
