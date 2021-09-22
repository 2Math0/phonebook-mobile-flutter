import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../rounded_button.dart';
import 'components/background_signUp.dart';
import 'components/signUp_input_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 48,
                    fontFamily: 'Balsamiq',
                    fontWeight: FontWeight.w800,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Colors.transparent,
                  ),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 48,
                    color: kGearOrange,
                    fontFamily: 'Balsamiq',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(
              'assets/images/gear.svg',
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            SizedBox(
              height: 60,
            ),
            SignUpInput(
                hint: 'E-mail',
                icon: Icons.person,
                inputType: TextInputType.emailAddress),
            SizedBox(
              height: 40,
            ),
            SignUpInput(
                hint: 'Password', icon: Icons.lock, isPasswordFormat: true),
            SizedBox(
              height: 40,
            ),
            RoundedButton(
              text: 'Sign Up',
              color: kGearOrange,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already Signed Up ?',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontFamily: 'Balsamiq',
                      color: kGearOrange,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      elevation: MaterialStateProperty.all(0)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
