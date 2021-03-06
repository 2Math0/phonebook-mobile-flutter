import 'dart:convert';
import 'package:conca/widgets/password_input_field.dart';
import 'package:conca/Contacts/contacts.dart';
import 'package:conca/widgets/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:conca/Registering/RegisterPage.dart';
import 'package:conca/constants.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/background_logIn.dart';
import '../widgets/login_input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final loginKey = GlobalKey<FormState>();
  var errorMsg;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    // _isLoading = true;
    Future.delayed(Duration.zero, () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('token');
      if (token != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => ContactsPage()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(kDarkAccentColor),
      ));
    } else {
      return Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 48,
                      fontFamily: 'Balsamiq',
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.8
                        ..color = Colors.black
                        ..strokeCap = StrokeCap.butt,
                    ),
                  ),
                  Text(
                    'LOG IN',
                    style: TextStyle(
                      fontSize: 48,
                      color: kDarkAccentColor,
                      fontFamily: 'Balsamiq',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/images/shield.svg',
                alignment: Alignment.center,
                width:
                    size.width < 600 ? (size.width * 0.5).roundToDouble() : 300,
              ),
              SizedBox(
                height: 60,
              ),
              Form(
                key: loginKey,
                child: Column(children: [
                  NormalInputField(
                    hint: 'E-mail',
                    icon: Icons.person,
                    inputType: TextInputType.emailAddress,
                    textController: emailController,
                    validator: (v){return emailValidation(v);},
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  PasswordInputField(
                    hint: 'Password',
                    icon: Icons.lock,
                    textController: passwordController,
                    validator: (v){return passwordValidation(v);},
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ]),
              ),
              RoundedButton(
                text: 'Log In',
                color: kDarkAccentColor,
                press: () {
                  print("Login pressed");
                  if (loginKey.currentState.validate()) {
                    setState(() {
                      _isLoading = true;
                      Future.delayed(Duration(seconds: 12), () {
                        if (_isLoading == true) {
                          _isLoading = false;
                          snackBarCustom(context, kAccentColor,
                              Colors.transparent, 'time out');
                        }
                      });
                    });
                    loginCore(emailController.text, passwordController.text);
                  } else {
                    snackBarCustom(
                      context,
                      kAccentColor,
                      Colors.black87,
                      'Enter a valid email and 8 password characters at least',
                    );
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not Signed in ?',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Balsamiq',
                        color: kSemiDarkAccentColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0)),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
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

  loginCore(String email, String pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> data = {"email": '$email', "password": "$pass"};
    var jsonResponse;
    var response = await http.post(
      Uri.parse("${API_URL}login"),
      body: json.encode(data),
      headers: kJsonAPP,
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
            context, kSemiDarkAccentColor, Colors.black87, errorMsg.toString());
        _isLoading = false;
      });
    }
  }
}
