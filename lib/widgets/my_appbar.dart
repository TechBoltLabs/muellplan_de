// lib/widgets/my_appbar.dart

import 'package:flutter/material.dart';

import '../constants/constants_barrel.dart';

// the appbar widget of the app
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.title, bool showDrawerIcon = true}) : super(key: key);

  // variable for the title of the app
  final String title;

  // set the height of the appbar
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          size: 40.0,
        ),
        tooltip: 'Menü',
        onPressed: () => _saveLocationAndCategorySettingsAndOpenDrawer(context),
      ),
      // padding on the left side
      title: Padding(
        padding: const EdgeInsets.only(left: 85.0),
        // row element for the title (easier positioning)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // the title of the app
            Text(
              title,
              style: const TextStyle(
                fontSize: fontSizeHeading,
                fontFamily: fontFamilyDefault,
              ),
            ),
            // FIXME: remove this text when site is finished
            // a text to show that the site is still in development
            Container(
              padding: const EdgeInsets.only(right: 40.0),
              child: const Text("Diese Seite befindet sich noch in der Entwicklung.",
                  style: TextStyle(
                      fontSize: fontSizeIncreased,
                      fontFamily: fontFamilyDefault,
                      color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: does this method make sense???
// function to save the location and category settings and open the drawer
void _saveLocationAndCategorySettingsAndOpenDrawer(BuildContext context) async{
  // save the location and category settings


  Scaffold.of(context).openDrawer();
}