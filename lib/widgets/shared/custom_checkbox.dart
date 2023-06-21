// lib/widgets/shared/custom_checkbox.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/map_and_location_notifier.dart';
import '../../../constants/constants_barrel.dart';
import '../../../models/custom_elements/decorations.dart';

// a custom checkbox widget for selecting litter categories to be displayed on the homepage
class MuellplanAPPCustomCheckbox extends StatefulWidget {
  // variables for storing the label, the width and the litter category of the checkbox
  final String label;
  final double checkBoxFieldWidth;
  final String? litterCategory;

  // constructor
  const MuellplanAPPCustomCheckbox(
      {Key? key,
        // default value for label is 'label'
        this.label = 'label',
        // TODO: make the width of the checkbox field responsive
        required this.checkBoxFieldWidth,
        this.litterCategory})
      : super(key: key);

  @override
  _MuellplanAPPCustomCheckboxState createState() =>
      _MuellplanAPPCustomCheckboxState();
}

class _MuellplanAPPCustomCheckboxState
    extends State<MuellplanAPPCustomCheckbox> {
  // variables for storing the checkbox value, the litter category and the label
  late bool _isChecked;
  late String? _litterCategory;
  late String _label;

  // TODO: make the width of the checkbox field responsive
  late final double _checkBoxFieldWidth;

  @override
  void initState() {
    super.initState();
    _litterCategory = widget.litterCategory;
    _label = getHeadingForLabel(_litterCategory, widget.label);
    _checkBoxFieldWidth = widget.checkBoxFieldWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapAndLocationNotifier>(
      builder: (context, notifier, child) {
        // get the checkbox value from the mapAndLocationNotifier
        // default value for checkbox is false
        _isChecked = notifier.checkedCategories[_litterCategory] ?? false;

        return InkWell( // InkWell is used to make the checkbox clickable
          onTap: () { // when the checkbox is clicked, the state of the widget is updated
            setState(() {
              // update the checkbox value in the mapAndLocationNotifier
              // and the value of the underlying checkbox
              // FIXME: extract the setState of the checkbox and the parent widget to one method (updateNotifierCheckboxValue)
              if (_litterCategory != null) {
                notifier.updateCheckboxValue(_litterCategory!,!notifier.checkedCategories[_litterCategory]!);
                _isChecked =notifier.checkedCategories[_litterCategory]!;
              }
            });
          },
          // the container for the checkbox field
          child: Container(
            margin: const EdgeInsets.all(8),
            width: _checkBoxFieldWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!, width: 1.5),
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                muellplanAPPCustomBoxShadow(),
              ],
            ),
            child:
                // TODO: change layout builder to container??? - or remove it
            LayoutBuilder(builder: (context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0, left: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // the checkbox
                    Checkbox(
                      value: notifier.checkedCategories[_litterCategory] ?? _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                          updateNotifierCheckboxValue(notifier, _litterCategory!, value);
                        });
                      },
                    ),
                    // the label
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _label,
                            style: const TextStyle(fontSize: fontSizeDefault),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// TODO: use this method in the checkbox widget twice (checkbox and its container)
void updateNotifierCheckboxValue(MapAndLocationNotifier notifier, String? litterCategory, bool value) {
  if (litterCategory != null) {
    notifier.updateCheckboxValue(litterCategory, value);
  }
}



// class MuellplanAPPCustomCheckboxNew extends StatefulWidget {
//   final String label;
//   final String? litterCategory;
//
//   const MuellplanAPPCustomCheckboxNew(
//       {Key? key, this.label = 'label', this.litterCategory})
//       : super(key: key);
//
//   @override
//   _MuellplanAPPCustomCheckboxNewState createState() =>
//       _MuellplanAPPCustomCheckboxNewState();
// }
//
// class _MuellplanAPPCustomCheckboxNewState
//     extends State<MuellplanAPPCustomCheckboxNew> {
//   late bool _isChecked;
//   late String? _litterCategory;
//   late String _label;
//
//   @override
//   void initState() {
//     super.initState();
//     _litterCategory = widget.litterCategory;
//     _label = getHeadingForLabel(_litterCategory, widget.label);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MapAndLocationNotifier>(
//       builder: (context, mapAndLocationNotifier, child) {
//         // default value for checkbox is false
//         _isChecked =
//             mapAndLocationNotifier.checkedCategories[_litterCategory] ?? false;
//
//         return InkWell(
//           onTap: () {
//             setState(() {
//               if (_litterCategory != null) {
//                 mapAndLocationNotifier.updateCheckboxValue(
//                     _litterCategory!,
//                     !mapAndLocationNotifier
//                         .checkedCategories[_litterCategory]!);
//                 _isChecked =
//                 mapAndLocationNotifier.checkedCategories[_litterCategory]!;
//               }
//             });
//           },
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.grey[400]!,
//                   width: 1.5,
//                 ),
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(7),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 0.5,
//                     blurRadius: 1,
//                     offset: const Offset(1, 1),
//                   )
//                 ]),
//             child: Row(
//               children: [
//                 Checkbox(
//                   value: _isChecked,
//                   onChanged: (bool? value) {
//                     mapAndLocationNotifier.updateCheckboxValue(
//                         _litterCategory!, value!);
//                     _isChecked = mapAndLocationNotifier
//                         .checkedCategories[_litterCategory]!;
//                   },
//                 ),
//                 Text(
//                   _label,
//                   style: const TextStyle(
//                     fontSize: fontSizeDefault,
//                     fontFamily: fontFamilyDefault,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }