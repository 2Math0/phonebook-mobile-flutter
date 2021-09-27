import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class RegisterInput extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final bool isPasswordFormat;
  final TextEditingController textController;

  const RegisterInput(
      {@required this.hint,
      @required this.icon,
      this.inputType = TextInputType.text,
      this.isPasswordFormat = false,
        this.textController});
  @override
  _RegisterInputState createState() => _RegisterInputState();
}

class _RegisterInputState extends State<RegisterInput> {
  bool hidePassword = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorder(
      color: Colors.black38,
      borderType: BorderType.RRect,
      radius: Radius.circular(50),
      strokeWidth: 4,
      strokeCap: StrokeCap.round,
      dashPattern: [size.width * 0.3, 8, size.width * 0.5, 24],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: kGearYellow,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: TextField(
          cursorColor: kGearOrange,
          keyboardType: widget.inputType,
          obscureText: hidePassword,
          autofocus: !widget.isPasswordFormat,
          controller: widget.textController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: kGearOrange,
            ),
            suffixIcon: widget.isPasswordFormat
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                    color: kGearOrange.withOpacity(!hidePassword ? 0.4 : 1),
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
