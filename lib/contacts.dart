import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Map items = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView.builder(
            itemBuilder: (BuildContext context, i) {
              return ListTile(
                leading: Icon(
                  Mdi.alphaACircle,
                  color: Colors.red,
                  size: MediaQuery.of(context).size.width * 0.15,
                ),
                title: Text('hani'),
              );
            },
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}
