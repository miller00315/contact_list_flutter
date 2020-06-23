import 'dart:io';

import 'package:contacts/db/entities/contact.dart';
import 'package:flutter/material.dart';

Widget contactItem(
  BuildContext context,
  int index,
  Contact contact,
  Function showContactPage,
) {
  return GestureDetector(
    onTap: () => showContactPage(context, index),
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: contact.image != null
                      ? FileImage(
                          File(contact.image),
                        )
                      : AssetImage('images/default.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contact.name ?? '',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    contact.email ?? '',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    contact.phone ?? '',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
