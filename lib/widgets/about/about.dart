// lib/widgets/about/about.dart

// currently not used
// TODO: implement the use of this widget

import 'package:flutter/material.dart';

import '../my_appbar.dart';
import '../../drawer.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MyAppBar(title: "Über diese App"),
      drawer: MuellplanAPPDrawer(),
      body: Center(
        child: Text("Über diese App"),
      ),
    );
  }
}