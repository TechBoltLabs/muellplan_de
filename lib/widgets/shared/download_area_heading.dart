// lib/widgets/shared/download_area_heading.dart

// import libraries
import 'package:flutter/material.dart';

// import local files
import '../../constants/constants_barrel.dart';

class DownloadAreaHeading extends StatelessWidget {
  const DownloadAreaHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: Text(
        'Kalender-Download:',
        style: TextStyle(
          fontSize: fontSizeIncreased,
          fontFamily: fontFamilyDefault,
        ),
      ),
    );
  }
}
