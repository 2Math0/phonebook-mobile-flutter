import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LoginInput extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPasswordFormat;
  final TextInputType inputType;
  final TextEditingController textController;

  const LoginInput(
      {@required this.hint,
      @required this.icon,
      this.isPasswordFormat = false,
      this.inputType = TextInputType.text, this.textController});

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  bool hidePassword = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorder(
      color: Colors.black,
      borderType: BorderType.RRect,
      radius: Radius.circular(50),
      strokeWidth: 4,
      strokeCap: StrokeCap.round,
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
          keyboardType: widget.inputType,
          obscureText: hidePassword,
          autofocus: !widget.isPasswordFormat,
          controller: widget.textController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Colors.black,
            ),
            suffixIcon: widget.isPasswordFormat
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                    color: Colors.black.withOpacity(!hidePassword ? 0.4 : 1),
                  )
                : null,
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.black38),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
