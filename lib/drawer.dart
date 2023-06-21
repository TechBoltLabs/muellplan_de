// lib/drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:muellplan_de/constants/constants_barrel.dart';

class MuellplanAPPDrawer extends StatelessWidget {
  const MuellplanAPPDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      key: const Key('muellplan-app-drawer'),
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'muellplan.de',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSizeHeading,
              ),
            ),
          ),
          ListTile(
            title: const Text('Startseite',
                style: TextStyle(
                  fontSize: fontSizeIncreased,
                )),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          const DrawerDash(),
          ListTile(
            title: const Text('E-Mail Benachrichtigung',
                style: TextStyle(
                  fontSize: fontSizeIncreased,
                )),
            onTap: () {
              Navigator.pushNamed(context, '/mail-subscription');
            },
          ),
          const DrawerDash(),
          // ListTile(
          //   title: const Text('Über diese App',
          //       style: TextStyle(
          //         fontSize: fontSizeIncreased,
          //       )),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/about');
          //   },
          // ),
          // Element with no transition animation
          // ListTile(
          //   title: const Text('no transition'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       PageRouteBuilder(
          //         pageBuilder: (context, animation1, animation2) =>
          //             const HomePage(title: 'muellplan.de'),
          //         transitionDuration: const Duration(seconds: 0),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}


class DrawerDash extends Dash{
  const DrawerDash({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Dash(
      direction: Axis.horizontal,
      length: 300,
      dashLength: 2,
      dashGap: 2,
      dashColor: Colors.grey,
    );
  }
}