// lib/routes.dart

import 'constants/project_settings.dart';
import 'widgets/homepage/homepage.dart';
import 'widgets/mail-subscription/mail-subscription.dart';
import 'widgets/about/about.dart';

var appRoutes = {
  '/': (context) => const HomePage(title: projectTitle,),
  '/mail-subscription': (context) => const MailSubscription(),
  '/about': (context) => const About(),
};