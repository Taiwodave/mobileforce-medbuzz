import 'package:flutter/material.dart';

ThemeData appThemeDark = ThemeData(
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(),
      color: Color(0xff333333),
      iconTheme: IconThemeData(color: Colors.white70),
    ),
    //this color is used for the 'see all' text in [HomeScreen]0xfff4f4f4
    textSelectionColor: Color(0xff2D7DD2),
    // this color is used by text in the upcoming appointments card shown on the home screen
    dividerColor: Color(0xff777777),
    //this color is used by date (day) in the upcoming appointments card shown on the home screen
    focusColor: Color(0xff2DBFC3),
    brightness: Brightness.dark,
    cursorColor: Color(0xfff4f4f4),
    primaryColor: Color(0xff617ADC),
    highlightColor: Color.fromARGB(255, 45, 191, 195),
    accentColor: Color(0xff219653),
    primaryColorLight: Colors.black54,
    primaryColorDark: Colors.white,
    backgroundColor: Color(0xff333333),
    buttonColor: Color(0xffF2994A),
    hintColor: Color(0xff777777),
    textTheme: TextTheme(
      headline1: TextStyle().copyWith(fontFamily: 'Segoe'),
      headline2: TextStyle().copyWith(fontFamily: 'Segoe'),
      headline4: TextStyle().copyWith(fontFamily: 'Segoe'),
      headline3: TextStyle().copyWith(fontFamily: 'Segoe'),
      bodyText2: TextStyle().copyWith(fontFamily: 'Segoe'),
      bodyText1: TextStyle().copyWith(fontFamily: 'Segoe'),
      headline5: TextStyle().copyWith(fontFamily: 'Segoe'),
      headline6: TextStyle().copyWith(fontFamily: 'Segoe'),
      caption: TextStyle().copyWith(fontFamily: 'Segoe'),
      button: TextStyle().copyWith(fontFamily: 'Segoe'),
      overline: TextStyle().copyWith(fontFamily: 'Segoe'),
    ));
