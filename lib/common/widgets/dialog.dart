import 'package:flutter/material.dart';

Future<void> showCustomDialog({required BuildContext context, Widget? title, Widget? content, List<Widget>? actions}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          ...?actions,
          TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                  '关闭',
                style: TextStyle(
                  color: Colors.red,
                ),
              )
          ),
        ],
      );
    },
  );
}