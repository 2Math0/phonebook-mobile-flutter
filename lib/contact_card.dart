import 'package:conca/Contacts/alpha_icons_generator.dart';
import 'package:conca/add_contact.dart';
import 'package:conca/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'contacts.dart';

class ContactCard extends StatelessWidget {
  final Map contactDetails;
  final Color mainIconColor;
  const ContactCard(
      {@required this.contactDetails,
      this.mainIconColor = kSemiDarkAccentColor});

  @override
  Widget build(BuildContext context) {
    void handleClick(String value) {
      switch (value) {
        case 'Edit':
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactADD(
                    nameUpdate: contactDetails['name'].toString(),
                    emailUpdate: contactDetails['email'],
                    phoneUpdate: contactDetails['phones'][0]['value'],
                    notesUpdate: contactDetails['notes'],
                    id: contactDetails['id'],
                    updateMode: true,
                  )),
                  (Route<dynamic> route) => false);
          break;
        case 'Delete':
          Future.delayed(Duration.zero, () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String token = prefs.getString("token");
            final response = await http.delete(
                Uri.parse('${API_URL}contacts/${contactDetails['id']}'),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token',
                });
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => ContactsPage()),
                  (Route<dynamic> route) => false);
          break;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: <Widget>[
          PopupMenuButton<String>(
            padding: EdgeInsets.all(32),
            onSelected: handleClick,
            icon: Icon(Icons.menu,color: mainIconColor,size: 32,),
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            children: <Widget>[
              Center(
                child: Icon(
                  mdiIcons[contactDetails['name'][0].toString().toUpperCase()],
                  size: 160,
                  color: mainIconColor,
                ),
              ),
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.person,
                    size: 32,
                    color: mainIconColor,
                  ),
                  SizedBox(width: 32),
                  Text(
                    contactDetails['name'] == null
                        ? ''
                        : contactDetails['name'],
                    style: kNormalTextStyle.copyWith(letterSpacing: 4),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.envelope,
                    size: 32,
                    color: mainIconColor,
                  ),
                  SizedBox(width: 32),
                  Text(
                      contactDetails['email'] == null
                          ? 'no Email'
                          : contactDetails['email'],
                      style: kNormalTextStyle),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.phone,
                    size: 32,
                    color: mainIconColor,
                  ),
                  SizedBox(width: 32),
                  Text(
                    contactDetails['phones'][0]['value'],
                    style: kNormalTextStyle,
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.book,
                    size: 32,
                    color: mainIconColor,
                  ),
                  SizedBox(width: 32),
                  Text(
                    contactDetails['notes'] == null
                        ? 'No notes for this contact'
                        : contactDetails['notes'],
                    style: kNormalTextStyle,
                    softWrap: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
