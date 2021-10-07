import 'package:conca/widgets/dotted_Field.dart';
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
    return InputDottedBorder(
      random: stepOneIgnoreOne(randomDoubles(), size.width),
      borderColor: Colors.black54,
      background: kGearYellow,
      myChild: TextField(
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
                  icon: Icon(
                      hidePassword ? Icons.visibility : Icons.visibility_off),
                  color: kGearOrange.withOpacity(!hidePassword ? 0.4 : 1),
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
