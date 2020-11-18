import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createTitleBarWidget(BuildContext context) {
  return Container(
    height: 100.0,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(40),
      ),
      color: Color.fromRGBO(62, 213, 187, 100),
      boxShadow: [
        BoxShadow(
          blurRadius: 10.0,
          color: Colors.blueGrey,
          offset: Offset(0.0, 4),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.only(top: 35.0, left: 30.0),
      child: Text(
        'Calendar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
