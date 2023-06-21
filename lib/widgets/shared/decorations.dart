// lib/widgets/shared/decorations.dart

import 'package:flutter/material.dart';

// custom border decoration with rounded corners and shadow
BoxDecoration muellplanAPPCustomBorderDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(
      color: Colors.black,
      width: 0.4,
    ),
    color: Colors.white,
    boxShadow: [
      muellplanAPPCustomBoxShadow(),
    ],
  );
}

// custom shadow for containers and similar
BoxShadow muellplanAPPCustomBoxShadow() {
  return BoxShadow(
    color: Colors.grey.withOpacity(0.5),
    spreadRadius: 0.5,
    blurRadius: 1,
    offset: const Offset(2, 2),
  );
}