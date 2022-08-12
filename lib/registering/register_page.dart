/*
This page has the design and the response of registering
Design:
First it has the parent Background Class from background_register.dart
its child is a column with Painted Text, SVG, two inputs one for user name and other for password
finally a navigator to Log In if user already has one

Response:
first it initializes shared Preferences
then send email and pass to API in a Map and save this map in Shared Preferences
finally, Navigates to Contacts page

 */

import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:conca/Contacts/contacts.dart';
import 'package:conca/constants.dart';
import 'package:conca/registering/components/background_register.dart';
import 'package:conca/widgets/dotted_input_field.dart';
import 'package:conca/widgets/dotted_obscure_field.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:conca/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Log_in/log_in_page.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final signUpKey = GlobalKey<FormState>();
  dynamic errorMsg;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Text(
                        'Registration',
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
                      const Text(
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
                    width: size.width < 600
                        ? (size.width * 0.5).roundToDouble()
                        : 300,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Form(
                    key: signUpKey,
                    child: Column(
                      children: <Widget>[
                        NormalInputField(
                          hint: 'E-mail',
                          icon: Icons.person,
                          inputType: TextInputType.emailAddress,
                          textController: emailController,
                          validator: (value) {
                            return emailValidation(value);
                          },
                          bgColor: kGearYellow,
                          textColor: Colors.black,
                          iconColor: kGearOrange,
                          borderColor: Colors.black.withOpacity(0.65),
                          cursorColor: kGearOrange,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        PasswordInputField(
                          hint: 'Password',
                          icon: Icons.lock,
                          textController: passwordController,
                          validator: (value) {
                            return passwordValidation(value);
                          },
                          bgColor: kGearYellow,
                          textColor: Colors.black,
                          iconColor: kGearOrange,
                          borderColor: Colors.black.withOpacity(0.65),
                          cursorColor: kGearOrange,
                        ),
                        const SizedBox(height: 40),
                        RoundedButton(
                          text: 'Sign Up',
                          color: kGearOrange,
                          press: () {
                            if (signUpKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                                Future.delayed(const Duration(seconds: 12), () {
                                  if (_isLoading == true) {
                                    _isLoading = false;
                                    snackBarCustom(context, Colors.white,
                                        Colors.transparent, 'time out');
                                  }
                                });
                              });
                              registerResponse(emailController.text,
                                  passwordController.text);
                            } else {
                              snackBarCustom(
                                context,
                                kGearGrey,
                                Colors.black.withOpacity(0.6),
                                'Enter a valid email and 8 password characters at least',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Signed Up ?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            elevation: MaterialStateProperty.all(0)),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LogInPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: 'Balsamiq',
                            color: kGearOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void registerResponse(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, 'name': getRandomString(7)};
    dynamic jsonResponse;
    var response = await http.post(
      Uri.parse("${apiURL}register"),
      body: json.encode(data),
      headers: kJsonAPP,
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      log(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => const ContactsPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      errorMsg = response.body;
      setState(() {
        snackBarCustom(context, kGearGrey, Colors.black.withOpacity(0.6),
            errorMsg.toString());
        _isLoading = false;
      });
      log("The error message is: ${response.body} ${emailController.text}");
    }
  }
}

const _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890 ';
math.Random _rnd = math.Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
