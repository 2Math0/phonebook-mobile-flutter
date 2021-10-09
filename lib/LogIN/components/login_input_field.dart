import 'package:conca/widgets/dotted_Field.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class LoginInput extends StatefulWidget {
  final String hint;
  final IconData icon;
  final bool isPasswordFormat;
  final TextInputType inputType;
  final TextEditingController textController;
  final String Function(String) validator;

  const LoginInput(
      {@required this.hint,
      @required this.icon,
      this.isPasswordFormat = false,
      this.inputType = TextInputType.text,
      this.textController, this.validator});

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  bool hidePassword = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InputDottedBorder(
      background: kAccentColor,
      borderColor: Colors.black,
      random: stepOneIgnoreOne(randomDoubles(), size.width),
      myChild: TextFormField(
        cursorColor: kDarkAccentColor,
        keyboardType: widget.inputType,
        obscureText: hidePassword,
        // autofocus: !widget.isPasswordFormat,
        controller: widget.textController,
        validator: widget.validator,
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
        style: kNormalTextStyle,
      ),
    );
  }
}
