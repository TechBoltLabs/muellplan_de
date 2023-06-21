// lib/widgets/shared/collection_dates_didnt_load_hint.dart

// import libraries
import 'package:flutter/material.dart';

// import local files
import '../../constants/constants_barrel.dart';

// the widget to display when the collection dates didn't load
class CollectionDatesDidntLoadHint extends StatelessWidget {
  const CollectionDatesDidntLoadHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ups! Da ist etwas schief gelaufen.',
            style: TextStyle(
              fontSize: fontSizeDefault,
              fontFamily: fontFamilyDefault,
              color: Colors.deepOrange,
            ),
          ),
          Text(
              'Bitte versuchen Sie, den Ort und die Straße erneut auszuwählen.',
              style: TextStyle(
                fontSize: fontSizeDefault,
                fontFamily: fontFamilyDefault,
                color: Colors.deepOrange,
              )),
        ],
      ),
    );
  }
}