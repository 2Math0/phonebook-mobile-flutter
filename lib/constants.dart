import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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


Color randomColor ()=> Colors.primaries[Random().nextInt(Colors.primaries.length)];

List<double> randomDoubles(){
  var random = new Random();

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  List<double> theList = [
    doubleInRange(random, 0.1, 0.8),
    random.nextInt(100)+12.toDouble(),
    doubleInRange(random, 0.1, 0.8),
    random.nextInt(40).toDouble()
  ];
  return theList;
}

List<double>  stepOneIgnoreOne(l,width) {
  for (var i = 0; i <= 3; i += 2) {
    l[i] = l[i] * width;
  }
  return l;
}