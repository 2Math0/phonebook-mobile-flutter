import 'package:conca/constants.dart';
import 'package:conca/rounded_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'components/background_logIn.dart';
import 'components/login_input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'LOG IN',
              style: TextStyle(
                  fontSize: 48,
                  color: kDarkAccentColor,
                  fontFamily: 'Balsamiq',
                  fontWeight: FontWeight.w800),
            ),
            SvgPicture.asset(
              'assets/images/shield.svg',
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            SizedBox(
              height: 60,
            ),
            LoginInput(
                hint: 'E-mail',
                icon: Icons.person,
                inputType: TextInputType.emailAddress),
            SizedBox(
              height: 40,
            ),
            LoginInput(
                hint: 'Password', icon: Icons.lock, isPasswordFormat: true),
            SizedBox(
              height: 40,
            ),
            RoundedButton(
              text: 'Log In',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not Signed in ?',
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontFamily: 'Balsamiq',
                      color: kSemiDarkAccentColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0)
                  ),
                  onPressed: (){},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
