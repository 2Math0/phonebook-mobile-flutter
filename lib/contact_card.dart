import 'package:conca/Contacts/alpha_icons_generator.dart';
import 'package:conca/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Map contactDetails;
  final Color mainIconColor;
  const ContactCard({@required this.contactDetails, this.mainIconColor = kSemiDarkAccentColor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text(contactDetails['email']==null ? 'no Email' : contactDetails['email'], style: kNormalTextStyle),
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
