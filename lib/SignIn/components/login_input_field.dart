import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPasswordFormat;
  final TextInputType inputType;

  const LoginInput(
      {@required this.hint,
      @required this.icon,
      this.isPasswordFormat = false,
      this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorder(
      color: Colors.black,
      borderType: BorderType.RRect,
      radius: Radius.circular(50),
      strokeWidth: 4,
      strokeCap: StrokeCap.butt,
      dashPattern: [size.width * 0.3, 8, size.width * 0.5, 24],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: kAccentColor,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: TextField(
          cursorColor: kDarkAccentColor,
          keyboardType: inputType,
          obscureText: isPasswordFormat,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}