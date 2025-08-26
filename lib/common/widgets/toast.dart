import 'package:flutter/material.dart';

Future<void> showSnackbar({required BuildContext context, required Widget content, Duration duration = const Duration(seconds: 4)}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      duration: duration,
    ),
  );
}