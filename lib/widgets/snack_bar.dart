import 'package:conca/constants.dart';
import 'package:flutter/material.dart';

void snackBarCustom(
    BuildContext context, Color bg, Color borderColor, String message,
    {Color textColor = Colors.black}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 5),
      content: Container(
        alignment: Alignment.topCenter,
        constraints: const BoxConstraints(
          maxHeight: 100,
          minHeight: 50,
        ),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Center(
            child: Text(
              message,
              softWrap: true,
              style: kNormalTextStyle.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    ),
  );
}
