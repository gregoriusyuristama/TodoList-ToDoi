import 'package:flutter/material.dart';

const kDefaultColor = Color.fromRGBO(75, 191, 221, 1.0);

InputDecoration kRegisterFieldDecoration(bool isError) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: kDefaultColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.grey[400]!,
      ),
    ),
    labelStyle: TextStyle(
      color: Colors.grey[400],
    ),
    floatingLabelStyle: TextStyle(
      color: isError ? Colors.red : kDefaultColor,
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.red,
      ),
    ),
    errorStyle: const TextStyle(
      color: Colors.red,
    ),
  );
}

const kRegisterTextStyleDecoration = TextStyle(
  color: kDefaultColor,
  fontWeight: FontWeight.normal,
);

const kBottomSheetFieldDecoration = InputDecoration(
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(75, 191, 221, 1.0)),
  ),
  focusColor: Color.fromRGBO(75, 191, 221, 1.0),
  floatingLabelStyle: TextStyle(color: Color.fromRGBO(75, 191, 221, 1.0)),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(75, 191, 221, 1.0)),
  ),
);

const kTodoBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(40),
  ),
  color: Color.fromRGBO(247, 251, 255, 1.0),
);
const kTodoBoxDecorationLandscape = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(40),
    bottomLeft: Radius.circular(40),
  ),
  color: Color.fromRGBO(247, 251, 255, 1.0),
);

const kModalBotomSheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(25.0),
  ),
);

const kDefaultBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(75, 191, 221, 1.0),
      Color.fromRGBO(138, 218, 237, 1.0),
    ],
  ),
);

const kTextFieldTextStyle = TextStyle(
  color: kDefaultColor,
  fontWeight: FontWeight.normal,
);

const kDefaultTextColor = TextStyle(
  color: kDefaultColor,
);

const kTitleWidgetCardPadding = EdgeInsets.only(
  top: 15.0,
  left: 30,
  right: 30,
  // bottom: 15,
);

const kTitleToDoBox = TextStyle(
  color: Colors.black,
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const kBorderRadiusFinishedLandscape = BorderRadius.only(
  topLeft: Radius.circular(40),
  bottomLeft: Radius.circular(40),
);

const kCounterCardDecoration = BoxDecoration(
  shape: BoxShape.circle,
  // borderRadius: BorderRadius.circular(50),
  color: Color.fromRGBO(244, 183, 132, 1.0),
);

const kCounterCardMargin = EdgeInsets.all(5);
const kCounterCardWidth = 40.0;
const kCounterCardHeight = 50.0;

const kCounterTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

const kCounterTitleTextStyle = TextStyle(
  fontSize: 18,
);

const kCounterFinishedDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  // borderRadius: BorderRadius.circular(50),
  color: Color.fromRGBO(244, 183, 132, 1.0),
);
