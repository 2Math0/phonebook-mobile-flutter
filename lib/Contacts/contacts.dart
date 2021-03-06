import 'dart:convert';
import 'dart:ui';
import 'package:conca/Contacts/add_contact.dart';
import 'package:conca/constants.dart';
import 'package:conca/Contacts/contact_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List _contactsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(kDarkAccentColor),
            ))
          : SafeArea(
              child: Container(
                child: RefreshIndicator(
                  onRefresh: () {
                    return _fetchData();
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(6),
                    itemCount:
                        _contactsList.length == 0 ? 0 : _contactsList.length,
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
                              style: TextStyle(
                                fontFamily: 'Balsamiq',
                                fontWeight: FontWeight.w600,
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              _contactsList[i]['phones'].length >= 1
                                  ? _contactsList[i]['phones'][0]['value']
                                  : '',
                              softWrap: true,
                              style: TextStyle(
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
                          contentPadding: EdgeInsets.all(8),
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
                                transitionDuration: Duration(milliseconds: 300),
                                context: context,
                                transitionBuilder:
                                    (context, anim1, anim2, child) {
                                  return SlideTransition(
                                      position: Tween(
                                              begin: Offset(0, 1),
                                              end: Offset(0, 0))
                                          .animate(anim1),
                                      child: child);
                                },
                                pageBuilder: (ctx, anim1, anim2) => AlertDialog(
                                      title: Text("Delete Confirmation"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: kNormalTextStyle.copyWith(
                                              color: tileIconColor
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(
                                                side: BorderSide(
                                                    width: 2.0,
                                                    color: tileIconColor),
                                              ),
                                              primary: Colors.transparent,
                                              shadowColor: Colors.transparent),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteData(_contactsList[i]['id']);
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text(
                                            'Confirm',
                                            style: kNormalTextStyle.copyWith(
                                              color: tileIconColor,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              shape: StadiumBorder(
                                                side: BorderSide(
                                                    width: 2.0,
                                                    color: tileIconColor),
                                              ),
                                              primary: Colors.transparent,
                                              shadowColor: Colors.transparent),
                                        ),
                                      ],
                                      content: Text(
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
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: kAccentColor,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ContactADD()));
        },
      ),
    );
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.get(
      Uri.parse('${API_URL}contacts'),
      headers: headersToken(token),
    );
    final data = json.decode(response.body);
    setState(() {
      _contactsList = data['data'];
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteData(int n) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.delete(Uri.parse('${API_URL}contacts/$n'),
        headers: headersToken(token));
    final data = json.decode(response.body);
    setState(() {
      _contactsList = data['data'];
    });
    _fetchData();
  }
}
