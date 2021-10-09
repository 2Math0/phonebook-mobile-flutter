import 'dart:convert';
import 'dart:math' as math;
import 'package:conca/contacts.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:conca/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../widgets/rounded_button.dart';
import 'components/background_signUp.dart';
import 'components/register_input_field.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final signUpKey = GlobalKey<FormState>();
  var errorMsg;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
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
                    width: size.width < 600
                        ? (size.width * 0.5).roundToDouble()
                        : 300,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Form(
                    key: signUpKey,
                    child: Column(
                      children: <Widget>[
                        RegisterInput(
                          hint: 'E-mail',
                          icon: Icons.person,
                          inputType: TextInputType.emailAddress,
                          textController: emailController,
                          isPasswordFormat: false,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Email';
                            } else if (!value.contains('@')) {
                              return 'Enter a valid email Format like example@example.com';
                            }
                            return '';
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RegisterInput(
                          hint: 'Password',
                          icon: Icons.lock,
                          isPasswordFormat: true,
                          textController: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            } else if (value.length < 8) {
                              return 'the Password must be more than 8 characters';
                            }
                            return '';
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        RoundedButton(
                          text: 'Sign Up',
                          color: kGearOrange,
                          press: () {
                            if (signUpKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                                Future.delayed(Duration(seconds: 12), () {
                                  if (_isLoading == true) {
                                    _isLoading = false;
                                    snackBarCustom(context, Colors.white,
                                        Colors.transparent, 'time out');
                                  }
                                });
                              });
                              registerCore(emailController.text,
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

  registerCore(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass, 'name': getRandomString(7)};
    var jsonResponse;
    var response = await http.post(
      Uri.parse("https://phonebook-be.herokuapp.com/api/register"),
      body: json.encode(data),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
      },
    );
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => ContactsPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      errorMsg = response.body;
      setState(() {
        snackBarCustom(
            context,
            kGearGrey,
            Colors.black.withOpacity(0.6), errorMsg.toString());
        _isLoading = false;
      });
      print("The error message is: ${response.body} ${emailController.text}");
    }
  }
}

const _chars =
    'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890 ';
math.Random _rnd = math.Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
