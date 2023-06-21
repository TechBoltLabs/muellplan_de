// lib/widgets/muellplan_app.dart

// import libraries
import 'package:flutter/material.dart';

// import local files
import '../widgets/homepage/homepage.dart';
import '../routes.dart';
import '../constants/constants_barrel.dart';

// the main widget of the app
// this is the root of the project
class MuellplanAPP extends StatelessWidget {
  const MuellplanAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: appRoutes,
      title: 'Muellplan',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      // create a new HomePage widget with the title "muellplan.de"
      // home: const HomePage(title: projectTitle),
    );
  }
}