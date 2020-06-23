import 'package:flutter/material.dart';

Widget buildModalButton(String title, Function action, int index) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: FlatButton(
      onPressed: () => action(index),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.red,
          fontSize: 20.0,
        ),
      ),
    ),
  );
}
