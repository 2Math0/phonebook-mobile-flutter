import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:conca/Registering/RegisterPage.dart';
import 'package:conca/constants.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/background_signUp.dart';
import 'components/login_input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var errorMsg;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                    width: size.width < 600 ? (size.width * 0.5).roundToDouble() : 300,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  LoginInput(
                      hint: 'E-mail',
                      icon: Icons.person,
                      inputType: TextInputType.emailAddress,
                    textController: emailController,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  LoginInput(
                      hint: 'Password',
                      icon: Icons.lock,
                      isPasswordFormat: true,
                  textController: passwordController,),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedButton(
                    text: 'Log In',
                    color: kDarkAccentColor,
                    press: (){
                      print("Login pressed");
                      setState(() {
                        _isLoading = true;
                      });
                      loginCore(emailController.text, passwordController.text);
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
                          'Sign up',
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  loginCore(String mobile, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'mobile': mobile, 'password': pass};
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse("https://phonebook-be.herokuapp.com/api/login"),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['data']['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Register()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }
  }
}
