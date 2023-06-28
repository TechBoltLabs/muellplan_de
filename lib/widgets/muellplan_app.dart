// lib/widgets/muellplan_app.dart

// import libraries
import 'package:flutter/material.dart';

// import local files
import '../routes.dart';

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
      builder: (context, child) {
        return child != null
            ? MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        )
            : const SizedBox.shrink();
      },
      // create a new HomePage widget with the title "muellplan.de"
      // home: const HomePage(title: projectTitle),
    );
  }
}