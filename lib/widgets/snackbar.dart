import 'package:conca/constants.dart';
import 'package:flutter/material.dart';


class SnackBarCustom extends StatelessWidget {
  final Color borderColor;
  final String message;
  final Color bg;

  const SnackBarCustom({this.borderColor, this.message, this.bg});
  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
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
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  style: kNormalTextStyle.copyWith(color: borderColor),
                ),
              ),
              const Spacer(),
            ],
          )
      ),
    );
  }
}