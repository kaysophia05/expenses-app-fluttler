import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class AdapitativeTextField extends StatelessWidget {
  const AdapitativeTextField({
    this.label,
    this.controller,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    Key? key,
  }) : super(key: key);

  final String? label;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: CupertinoTextField(
              placeholder: label,
              controller: controller,
              onSubmitted: onSubmitted,
              keyboardType: keyboardType,
            ),
          )
        : TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
            ),
          );
  }
}
