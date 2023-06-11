import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptativeButton extends StatelessWidget {
  const AdaptativeButton(this.label, this.onPressed, {super.key});

  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Text(label),
          )
        : FilledButton(
            onPressed: onPressed,
            child: Text(label),
          );
  }
}
