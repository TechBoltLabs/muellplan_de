// lib/services/api/mail_subscription_service.dart

import 'dart:convert';

import '../../constants/constants_barrel.dart';
import 'general.dart';

Future<void> subscribeToMail(
    {required String name,
    required String email,
    required String locationCode,
    required String streetCode,
    required String daysBefore,
    required String time,
    required String categoriesStr}) async {
  String mailSubscriptionURL = "$backendHost/subscribe";

  Map<String, String> body = {
    'name': name,
    'email': email,
    'locationCode': locationCode,
    'streetCode': streetCode,
    'daysBefore': daysBefore,
    'notificationTime': time,
    'categories': categoriesStr
  };

  await postDocument(mailSubscriptionURL, body);
}

Future<bool> unsubscribeFromMail(String email) async {
  String mailSubscriptionURL = "$backendHost/unsubscribe";

  Map<String, String> body = {'email': email};

  bool response = await postDocument(mailSubscriptionURL, body);
  if(response){
    // TODO: use Logger
    print("Successfully unsubscribed $email");
    return true;
  } else {
    print("Failed to unsubscribe $email");
    return false;
  }
}