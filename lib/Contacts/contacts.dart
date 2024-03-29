/*
This one consider as the main home Page

It builds a list of saved contacts also has fetching and delete on long press
also a fab to add new contacts

The contact has a rule to follow the color as its alert dialog and contact screen will has the same represented color in ContactsPage

along the page if user needs to refresh the _isLoading bool will be true and so the screen will has Progress indicator child only
therefore any time user delete add refresh the _isLoading will change
 */

import 'dart:convert';

import 'package:conca/Contacts/add_contact.dart';
import 'package:conca/Contacts/contact_card.dart';
import 'package:conca/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List _contactsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kDarkAccentColor),
            ))
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () => _fetchData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(6),
                  itemCount: _contactsList.isEmpty ? 0 : _contactsList.length,
                  itemBuilder: (BuildContext context, i) {
                    Color tileIconColor = randomColor();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Hero(
                          tag:
                              '${_contactsList[i]['name']} ${_contactsList[i]['email']} ${_contactsList[i]['phones']}',
                          child: Icon(
                            contactIcon(_contactsList[i]['name']),
                            color: tileIconColor,
                            size: MediaQuery.of(context).size.width * 0.15,
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                          child: Text(
                            _contactsList[i]['name'],
                            softWrap: true,
                            style: const TextStyle(
                              fontFamily: 'Balsamiq',
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            _contactsList[i]['phones'].length >= 1
                                ? _contactsList[i]['phones'][0]['value']
                                : '',
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Balsamiq',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        onTap: () {
                          // print(_contactsList[i]);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => ContactCard(
                                    contactDetails: _contactsList[i],
                                    mainIconColor: tileIconColor,
                                  )));
                        },
                        contentPadding: const EdgeInsets.all(8),
                        trailing: CupertinoButton(
                          child: Icon(
                            Icons.call,
                            color: tileIconColor,
                            size: 32,
                          ),
                          onPressed: () => launchingLinks(
                              _contactsList[i]['phones'][0]['value'],
                              context,
                              'tel'),
                        ),
                        onLongPress: () {
                          showGeneralDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              context: context,
                              transitionBuilder:
                                  (context, anim1, anim2, child) {
                                return SlideTransition(
                                    position: Tween(
                                            begin: const Offset(0, 1),
                                            end: const Offset(0, 0))
                                        .animate(anim1),
                                    child: child);
                              },
                              pageBuilder: (ctx, anim1, anim2) => AlertDialog(
                                    title: const Text("Delete Confirmation"),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                  width: 2.0,
                                                  color: tileIconColor),
                                            ),
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent),
                                        child: Text(
                                          'Cancel',
                                          style: kNormalTextStyle.copyWith(
                                            color:
                                                tileIconColor.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          deleteData(_contactsList[i]['id']);
                                          Navigator.of(ctx).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                  width: 2.0,
                                                  color: tileIconColor),
                                            ),
                                            primary: Colors.transparent,
                                            shadowColor: Colors.transparent),
                                        child: Text(
                                          'Confirm',
                                          style: kNormalTextStyle.copyWith(
                                            color: tileIconColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                    content: const Text(
                                        "Are you sure to delete this contact?"),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccentColor,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const ContactADD()));
        },
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> get _fetchData async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.get(
      Uri.parse('${apiURL}contacts'),
      headers: headersToken(token),
    );
    final data = json.decode(response.body);
    setState(() {
      _contactsList = data['data'];
    });
    setState(() => _isLoading = false);
  }

  Future<void> deleteData(int n) async {
    setState(() => _isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.delete(Uri.parse('${apiURL}contacts/$n'),
        headers: headersToken(token));
    final data = json.decode(response.body);
    setState(() {
      _contactsList = data['data'];
    });
    // top update data after editing
    _fetchData;
  }
}
