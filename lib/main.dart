import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:praktikum_mobile_1/contact.dart';

Future<List<Contact>> getContacts() async {
  final jsonData = await rootBundle.loadString('assets/data/contacts.json');
  final list = json.decode(jsonData) as List<dynamic>;

  return list.map((e) => Contact.fromMap(e)).toList();
}

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  static const String _title = 'Contacts';

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: _title,
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Contacts'),
      ),
      child: SafeArea(
        child: FutureBuilder(
          future: getContacts(),
          builder: (context, data) {
            if (data.hasError) {
              return Center(
                child: Text("${data.error}"),
              );
            } else if (data.hasData) {
              List<Contact> contacts = data.data as List<Contact>;
              contacts.sort((a, b) => (a.name).compareTo(b.name));
              return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, i) {
                    return _buildRow(contacts[i]);
                  });
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRow(Contact contact) {
    return ContactWidget(
        contactName: contact.name,
        contactPhone: contact.phone,
        contactEmail: contact.email);
  }
}

class ContactWidget extends StatelessWidget {
  final String contactName;
  final String contactPhone;
  final String contactEmail;

  const ContactWidget(
      {Key? key,
      required this.contactName,
      required this.contactPhone,
      required this.contactEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Color.fromRGBO(82, 82, 80, 0.5)))),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child:
                RoundedImageWidget(imageLocation: 'assets/images/profile.jpg'),
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: Text(
                      contactName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    contactPhone,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(138, 138, 138, 1),
                        height: 1.5),
                  ),
                  Text(
                    contactEmail,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(138, 138, 138, 1),
                        height: 1.5),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundedImageWidget extends StatelessWidget {
  final double imageWidth;
  final double imageHeight;
  final String imageLocation;
  const RoundedImageWidget(
      {Key? key,
      this.imageWidth = 75,
      this.imageHeight = 75,
      required this.imageLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.imageWidth,
      height: this.imageHeight,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover, image: new AssetImage(this.imageLocation))),
    );
  }
}
