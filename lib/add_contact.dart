import 'dart:convert';
import 'package:conca/Contacts/alpha_icons_generator.dart';
import 'package:conca/constants.dart';
import 'package:conca/contacts.dart';
import 'package:conca/widgets/dotted_Field.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactADD extends StatefulWidget {
  @override
  _ContactADDState createState() => _ContactADDState();
}

class _ContactADDState extends State<ContactADD> {
  List<double> constantDots = stepOneIgnoreOne(randomDoubles(), 300);
  InputDottedBorder _dottedBorder(List<double> ran, Widget w) =>
      InputDottedBorder(
        myChild: w,
        background: Colors.white,
        borderColor: Colors.black,
        random: ran,
      );
  Color constantColor = randomColor();
  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final TextEditingController phone = new TextEditingController();
  final TextEditingController notes = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      mdiIcons[name.text.isEmpty
                          ? 'null'
                          : name.text[0].toUpperCase()],
                      size: 160,
                      color: constantColor,
                    ),
                    SizedBox(height: 64),
                    _dottedBorder(
                      constantDots,
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: constantColor,
                            ),
                            border: InputBorder.none,
                            hintText: 'name'),
                        autocorrect: false,
                        style: kNormalTextStyle,
                        onChanged: (str) {
                          setState(() {
                            name.text = str;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 32),
                    _dottedBorder(
                      constantDots,
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: constantColor,
                          ),
                          border: InputBorder.none,
                          hintText: 'email',
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        style: kNormalTextStyle,
                        controller: email,
                      ),
                    ),
                    SizedBox(height: 32),
                    _dottedBorder(
                      constantDots,
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: constantColor,
                            ),
                            border: InputBorder.none,
                            hintText: 'phone'),
                        autocorrect: false,
                        keyboardType: TextInputType.phone,
                        style: kNormalTextStyle,
                        controller: phone,
                      ),
                    ),
                    SizedBox(height: 32),
                    _dottedBorder(
                      constantDots,
                      TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.insert_drive_file,
                              color: constantColor,
                            ),
                            border: InputBorder.none,
                            hintText: 'notes'),
                        autocorrect: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: kNormalTextStyle,
                        controller: notes,
                      ),
                    ),
                    SizedBox(height: 128),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: size.width * 0.25,
              width: size.width * 0.5,
              child: RoundedButton(
                  text: 'ADD',
                  color: constantColor,
                  press: () {
                    uploadContact(
                        name.text, email.text, phone.text, notes.text);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (BuildContext context) => ContactsPage()),
                            (Route<dynamic> route) => false);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<ContactModel> uploadContact(
      String name, String email, String phones, String notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    var jsonBody = {
      'email': email,
      'name': name,
      'notes': notes,
      'phones': [
        {'value' : phones,
        'type_id' : 1}],
    };
    final response = await http.post(Uri.parse('${API_URL}contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(jsonBody));
    print(jsonBody);
    if (response.statusCode == 200) {
      return ContactModel.fromJson(jsonDecode(response.body));
    } else {
      print("The error message is: ${response.body}");
    }
  }
}

class ContactModel {
  final String email;
  final String name;
  final List<PhoneModel> phone;
  final String notes;

  ContactModel({this.email, this.name, this.phone, this.notes});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      email: json['email'],
      phone: json['phone'],
      notes: json['notes'],
      name: json['name'],
    );
  }
}

class PhoneModel {
  final int type_id;
  final String number;

  PhoneModel({this.type_id = 1, this.number});
}
