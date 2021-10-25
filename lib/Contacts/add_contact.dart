import 'dart:convert';
import 'package:conca/constants.dart';
import 'package:conca/Contacts/contacts.dart';
import 'package:conca/widgets/dotted_Field.dart';
import 'package:conca/widgets/rounded_button.dart';
import 'package:conca/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactADD extends StatefulWidget {
  final String nameUpdate;
  final String emailUpdate;
  final String phoneUpdate;
  final String notesUpdate;
  final bool updateMode;
  final int id;

  const ContactADD(
      {this.nameUpdate,
      this.emailUpdate,
      this.phoneUpdate,
      this.notesUpdate,
      this.updateMode = false,
      this.id});

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
  final contactKey = GlobalKey<FormState>();
  int numPhones = 1;
  final TextEditingController name = new TextEditingController();
  final TextEditingController email = new TextEditingController();
  final List<TextEditingController> phone =  [TextEditingController()];
  final TextEditingController notes = new TextEditingController();
  List<String> phones = [];
  String nameHolder;
  @override
  void initState() {
    checkUpdateMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nameHolder = name.text;
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
                      contactIcon(nameHolder),
                      size: 160,
                      color: constantColor,
                    ),
                    SizedBox(height: 64),
                    Form(
                      key: contactKey,
                      child: Column(
                        children: [
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
                              controller: name,
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'A name is required';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (str) {
                                setState(() {
                                  nameHolder = str;
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
                              validator: (v) {
                                if (v.isEmpty) {
                                  return 'email is required';
                                } else if (!v.contains('@')) {
                                  return 'enter valid email format';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, i) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
                                  child: _dottedBorder(
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
                                      controller: phone[i],
                                      validator: (v) {
                                        if (v.isEmpty) {
                                          return 'Phone is required';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: numPhones,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              color: constantColor,
                              iconSize: 28.0,
                              onPressed: () {
                                setState(() {
                                  numPhones++;
                                  phone.add(TextEditingController());
                                });
                              }),
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
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: size.width * 0.25,
              width: size.width * 0.5,
              child: RoundedButton(
                  text: widget.updateMode ? 'UPDATE' : 'ADD',
                  color: constantColor,
                  press: () {
                    if (contactKey.currentState.validate()) {
                      uploadContact(
                          name.text, email.text, phone, notes.text);
                    } else {
                      snackBarCustom(context, Colors.white, Colors.transparent,
                          'Not valid data');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<ContactModel> uploadContact(
      String name, String email, List<TextEditingController> phones, String notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    List<Map<String, dynamic>> phonesConverter(){
      List<Map<String,dynamic>> phoneList = [];
      for(int i=0; i<phones.length; i++){
        phoneList.add({'value':phones[i].text,'type_id':i+1});
      }
      print(phoneList);
      return phoneList;
    }
    var jsonBody = {
      'email': email,
      'name': name,
      'notes': notes,
      'phones': phonesConverter(),
    };
    final response = widget.updateMode
        ? await http.patch(
            Uri.parse('${API_URL}contacts/${widget.id.toString()}'),
            headers: headersToken(token),
            body: json.encode({
              'email': email,
              'name': name,
              'notes': notes,
            }))
        : await http.post(Uri.parse('${API_URL}contacts'),
            headers: headersToken(token), body: json.encode(jsonBody));
    print(jsonBody);
    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
          (Route<dynamic> route) => false);
      print(response.body);
      return ContactModel.fromJson(jsonDecode(response.body));
    } else {
      print("The error message is: ${response.body}");
      snackBarCustom(
          context, Colors.white, Colors.transparent, response.body.toString());
    }
  }

  void checkUpdateMode() {
    if (widget.nameUpdate != null) {
      name.text = widget.nameUpdate;
      email.text = widget.emailUpdate;
      phone[0].text = widget.phoneUpdate;
      notes.text = widget.notesUpdate;
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
