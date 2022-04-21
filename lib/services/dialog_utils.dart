import 'package:flutter/material.dart';

void showFailedDialog(
    {required BuildContext context, required Object exception}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Oops! Exception occurred!'),
            content: Text(exception.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'))
            ],
          ));
}

void showCannotDialog({required BuildContext context, required String reason}) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Operation cannot be done'),
            content: Text(reason),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'))
            ],
          ));
}
