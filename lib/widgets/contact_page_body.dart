import 'dart:io';

import 'package:contacts/db/entities/contact.dart';
import 'package:flutter/material.dart';

Widget contactPageBody(
  Contact contact,
  Function onChangedName,
  Function onChangePhone,
  Function onChangeEmail,
  TextEditingController nameController,
  TextEditingController phoneController,
  TextEditingController emailController,
  FocusNode nameFocus,
  Function changePhoto,
) {
  return SingleChildScrollView(
    padding: EdgeInsets.all(10.0),
    child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => changePhoto(),
          child: Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: contact.image != null
                    ? FileImage(
                        File(contact.image),
                      )
                    : AssetImage(
                        'images/default.png',
                      ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Nome'),
          onChanged: (text) => onChangedName(text),
          controller: nameController,
          focusNode: nameFocus,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Telefone'),
          onChanged: (text) => onChangePhone(text),
          keyboardType: TextInputType.phone,
          controller: phoneController,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (text) => onChangeEmail(text),
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
      ],
    ),
  );
}
