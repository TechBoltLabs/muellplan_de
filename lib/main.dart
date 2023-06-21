// import libraries
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import local files
import 'widgets/muellplan_app.dart';
import 'constants/constants_barrel.dart';
import 'notifiers/map_and_location_notifier.dart';
import 'services/services_barrel.dart';

// TODO: move lib/models/custom_elements/predefined_widgets to something like lib/widgets/shared/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapAndLocationNotifier mapAndLocationNotifier =
      MapAndLocationNotifier(initialCheckedCategories);

  await fetchLocations(mapAndLocationNotifier);

  runApp(ChangeNotifierProvider(
    create: (context) => mapAndLocationNotifier,
    child: const MuellplanAPP(),
  ));
}
