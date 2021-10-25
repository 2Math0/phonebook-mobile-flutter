import 'dart:math';
import 'package:conca/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'model/alpha_icons_generator.dart';
const estimatedHeight = 1100.00;
const estimatedWidth = 500.00;
const kAccentColor = Color(0xFF4ad194);
const kDarkAccentColor = Color(0xFF1e9690);
const kSemiDarkAccentColor = Color(0xFF35b79e);

const kGearYellow = Color(0xFFffda44);
const kGearOrange = Color(0xFFff9100);
const kGearGrey = Color(0xFFe1ebf0);
const kGearDarkGrey = Color(0xFFb4d2d7);
const kNormalTextStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Balsamiq',
  color: Colors.black,
);
const API_URL = 'https://phonebook-be.herokuapp.com/api/';
final Map<String, String> kJsonAPP = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
};

Color randomColor() =>
    Colors.primaries[Random().nextInt(Colors.primaries.length)];

List<double> randomDoubles() {
  var random = new Random();

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  List<double> theList = [
    doubleInRange(random, 0.1, 0.8),
    random.nextInt(100) + 12.toDouble(),
    doubleInRange(random, 0.1, 0.8),
    random.nextInt(40).toDouble()
  ];
  return theList;
}

List<double> stepOneIgnoreOne(l, width) {
  for (var i = 0; i <= 3; i += 2) {
    l[i] = l[i] * width;
  }
  return l;
}

Map<String, String> headersToken(token) {
  Map<String, String> headers = kJsonAPP;
  headers['Authorization'] = 'Bearer $token';
  return headers;
}

IconData contactIcon(listOfNames) => mdiIcons[listOfNames.isEmpty
            ? 'null'
            : listOfNames[0].toString().toUpperCase()] ==
        null
    ? Icons.person
    : mdiIcons[
        listOfNames.isEmpty ? 'null' : listOfNames[0].toString().toUpperCase()];
String emailValidation(value) {
  if (value.isEmpty) {
    return 'Please Enter Email';
  } else if (!value.contains('@')) {
    return 'Enter a valid email Format like example@example.com';
  }
  return null;
}

String passwordValidation(value) {
  if (value.isEmpty) {
    return 'Please Enter Password';
  } else if (value.length < 8) {
    return 'the Password must be more than 8 characters';
  }
  return null;
}

void launchingLinks(String l, BuildContext context, String type) async {
  // tel for phone calls
  // sms for messages
  // mailto for sending emails
  String url = '$type:$l';
  if (await UrlLauncher.canLaunch(url)) {
    await UrlLauncher.launch(url);
  } else {
    snackBarCustom(
        context, Colors.white, Colors.transparent, 'Could not launch $l');
  }
}
