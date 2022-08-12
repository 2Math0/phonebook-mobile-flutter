import 'package:conca/Contacts/add_contact.dart';
import 'package:conca/constants.dart';
import 'package:conca/model/phone_type.dart';
import 'package:conca/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'contacts.dart';

class ContactCard extends StatelessWidget {
  final Map contactDetails;
  final Color mainIconColor;
  const ContactCard(
      {Key? key,
      required this.contactDetails,
      this.mainIconColor = kSemiDarkAccentColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void snackBarMessage(response) => snackBarCustom(
        context, Colors.red, Colors.transparent, response.body.toString(),
        textColor: Colors.white);
    Map<String, List>? _phonesSeparator() {
      List<String> phonesList = [];
      List<int> phonesTypes = [];
      int l = contactDetails["phones"].length;
      if (l > 0) {
        for (int i = 0; i < l; i++) {
          phonesList.add(contactDetails["phones"][i]['value']);
          phonesTypes.add(contactDetails["phones"][i]['type_id']);
        }
        return {'numbers': phonesList, 'types': phonesTypes};
      }
      return null;
    }

    Map<String, List>? phonesSeparator = _phonesSeparator();
    void handleClick(String value) {
      switch (value) {
        case 'Edit':
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => ContactADD(
                  nameUpdate: contactDetails['name'].toString(),
                  emailUpdate: contactDetails['email'],
                  phoneUpdate: phonesSeparator!['numbers'] as List<String>,
                  typeUpdate: phonesSeparator['types'] as List<int>,
                  notesUpdate: contactDetails['notes'],
                  id: contactDetails['id'],
                  updateMode: true,
                ),
              ),
              (Route<dynamic> route) => false);
          break;
        case 'Delete':
          Future.delayed(Duration.zero, () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString("token");
            final response = await http.delete(
              Uri.parse('${apiURL}contacts/${contactDetails['id']}'),
              headers: headersToken(token),
            );
            snackBarMessage(response);
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
            padding: const EdgeInsets.all(32),
            onSelected: handleClick,
            icon: Icon(
              Icons.menu,
              color: mainIconColor,
              size: 32,
            ),
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
                child: Hero(
                  tag:
                      '${contactDetails['name']} ${contactDetails['email']} ${contactDetails['phones']}',
                  child: Icon(
                    contactIcon(contactDetails['name']),
                    size: 160,
                    color: mainIconColor,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.person,
                    size: 32,
                    color: mainIconColor,
                  ),
                  const SizedBox(width: 32),
                  Text(
                    contactDetails['name'] ?? '',
                    style: kNormalTextStyle.copyWith(letterSpacing: 4),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              RawMaterialButton(
                onPressed: () =>
                    launchingLinks(contactDetails['email'], context, 'mailto'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.envelope,
                      size: 32,
                      color: mainIconColor,
                    ),
                    const SizedBox(width: 32),
                    Text(contactDetails['email'] ?? 'no Email',
                        style: kNormalTextStyle),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                itemBuilder: (BuildContext context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: RawMaterialButton(
                      onPressed: () => launchingLinks(
                          contactDetails['phones'][i]['value'], context, 'tel'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            size: 32,
                            color: mainIconColor,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '${contactDetails['phones'][i]['value']} - ${mapPhoneTypeViewer[contactDetails['phones'][i]['type_id']]}',
                            style: kNormalTextStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: contactDetails['phones'].length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.book,
                    size: 32,
                    color: mainIconColor,
                  ),
                  const SizedBox(width: 32),
                  Text(
                    contactDetails['notes'] ?? 'No notes for this contact',
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
