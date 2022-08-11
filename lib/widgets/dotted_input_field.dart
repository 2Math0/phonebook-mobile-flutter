import 'package:conca/widgets/dotted_Field.dart';
import 'package:flutter/material.dart';
import 'package:conca/constants.dart';

class NormalInputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final TextEditingController textController;
  final String Function(String) validator;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final Color iconColor;
  final Color cursorColor;

  const NormalInputField(
      {@required this.hint,
      @required this.icon,
      this.inputType = TextInputType.text,
      this.textController,
      this.validator,
      this.bgColor = kAccentColor,
      this.borderColor = Colors.black,
      this.textColor = Colors.black,
      this.iconColor = Colors.black,
      this.cursorColor = kDarkAccentColor});

  @override
  _NormalInputFieldState createState() => _NormalInputFieldState();
}

class _NormalInputFieldState extends State<NormalInputField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DottedBorderWidget(
      background: widget.bgColor,
      borderColor: widget.borderColor,
      random: stepOneIgnoreOne(randomDoubles(), size.width),
      myChild: TextFormField(
        cursorColor: widget.cursorColor,
        keyboardType: widget.inputType,
        // obscureText: hidePassword,
        // autofocus: !widget.isPasswordFormat,
        controller: widget.textController,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: widget.iconColor,
          ),
          // suffixIcon: widget.isPasswordFormat
          //     ? IconButton(
          //         onPressed: () {
          //           setState(() {
          //             hidePassword = !hidePassword;
          //           });
          //         },
          //         icon: Icon(
          //             hidePassword ? Icons.visibility : Icons.visibility_off),
          //         color: Colors.black.withOpacity(!hidePassword ? 0.4 : 1),
          //       )
          //     : null,
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.black38),
          border: InputBorder.none,
        ),
        style: kNormalTextStyle.copyWith(color: widget.textColor),
      ),
    );
  }
}
