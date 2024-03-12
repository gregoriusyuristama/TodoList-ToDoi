import 'package:flutter/material.dart';

class ButtonToWelcomeScreen extends StatelessWidget {
  const ButtonToWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Text(
            'Back to Welcome Screen',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
