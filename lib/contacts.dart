import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:conca/Contacts/alpha_icons_generator.dart';
import 'package:conca/constants.dart';
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
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            padding: EdgeInsets.all(6),
            itemBuilder: (BuildContext context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Icon(
                    mdiIcons[
                        _contactsList[i]['name'][0].toString().toUpperCase()],
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                    size: MediaQuery.of(context).size.width * 0.15,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(12,12,0,0),
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
                    padding: EdgeInsets.fromLTRB(20,0,0,0),
                    child: Text(
                      _contactsList[i]['phones'][0]['value'],
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: 'Balsamiq',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  onTap: (){},
                  contentPadding: EdgeInsets.all(8),
                  onLongPress: (){},
                  trailing: CupertinoButton(
                    child: Icon(Icons.call,
                    color: kSemiDarkAccentColor,
                    size: 32,),
                    onPressed: (){
                      print(_contactsList[i]['id']);
                    },
                  ),
                ),
              );
            },
            itemCount: _contactsList.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add, color: Colors.white,),
        backgroundColor: kDarkAccentColor,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        onPressed: () {_fetchData();},
      ),
    );
  }

  Future<void> _fetchData() async {
    const API_URL = 'https://phonebook-be.herokuapp.com/api/contacts';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final response = await http.get(Uri.parse(API_URL), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    final data = json.decode(response.body);
    print(data);
    setState(() {
      _contactsList = data['data'];
    });
  }
}
