import 'package:contacts/db/entities/contact.dart';
import 'package:contacts/widgets/contact_item.dart';
import 'package:flutter/material.dart';

Widget homeBody(List<Contact> contacts, Function showContactPage) {
  return ListView.builder(
    padding: EdgeInsets.all(10.0),
    itemCount: contacts.length,
    itemBuilder: (context, index) => contactItem(
      context,
      index,
      contacts[index],
      showContactPage,
    ),
  );
}
