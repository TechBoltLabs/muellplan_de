// lib/widgets/homepage/category_settings.dart

import 'package:flutter/material.dart';

import '../../constants/constants_barrel.dart';
import '../shared/shared_barrel.dart';

class HomePageCategorySelection extends StatefulWidget {
  const HomePageCategorySelection({super.key});

  @override
  State<HomePageCategorySelection> createState() =>
      _HomePageCategorySelectionState();
}

class _HomePageCategorySelectionState extends State<HomePageCategorySelection> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 3;
    double widthWideCheckbox = width - 16;
    double widthNarrowCheckbox = widthWideCheckbox / 2 - 8;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Auswahl anpassen:',
                  style: TextStyle(fontSize: fontSizeDefault),
                ),
              ),
              // TODO: implement button "Anzeige zurücksetzen"
            ],
          ),
          Row(
            children: [
              Column(
                // category selection
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MuellplanAPPCustomCheckbox(
                    litterCategory: 'residual',
                    checkBoxFieldWidth: widthNarrowCheckbox,
                  ),
                  MuellplanAPPCustomCheckbox(
                    litterCategory: 'recycling',
                    checkBoxFieldWidth: widthNarrowCheckbox,
                  )
                ],
              ),
              Column(
                // category selection
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MuellplanAPPCustomCheckbox(
                    litterCategory: 'paper',
                    checkBoxFieldWidth: widthNarrowCheckbox,
                  ),
                  MuellplanAPPCustomCheckbox(
                    litterCategory: 'bio',
                    checkBoxFieldWidth: widthNarrowCheckbox,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              MuellplanAPPCustomCheckbox(
                litterCategory: 'residual_container',
                checkBoxFieldWidth: widthWideCheckbox,
              ),
            ],
          )
        ],
      );
    });
  }
}




// class HomePageCategorySelectionNew extends StatelessWidget {
//   const HomePageCategorySelectionNew({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//                 child: Column(
//                   children: [
//                     MuellplanAPPCustomCheckboxNew(litterCategory: 'residual'),
//                   ],
//                 )),
//             Expanded(
//               child: Column(
//                 children: [
//                   MuellplanAPPCustomCheckboxNew(
//                     litterCategory: 'paper',
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//                 child: Column(
//                   children: [
//                     MuellplanAPPCustomCheckboxNew(
//                       litterCategory: 'recycling',
//                     ),
//                   ],
//                 )),
//             Expanded(
//               child: Column(
//                 children: [
//                   MuellplanAPPCustomCheckboxNew(
//                     litterCategory: 'bio',
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//         Row(
//           children: [
//             Expanded(
//                 child: Column(
//                   children: [
//                     MuellplanAPPCustomCheckboxNew(
//                       litterCategory: 'residual_container',
//                     ),
//                   ],
//                 )),
//           ],
//         )
//       ],
//     );
//   }
// }
