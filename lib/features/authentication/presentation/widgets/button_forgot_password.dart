import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../screen/reset_password.dart';

class ButtonForgotPassword extends StatelessWidget {
  const ButtonForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          ),
        );
      },
      child: const Text(
        'Forgot Password',
        style: TextStyle(
          color: kDefaultColor,
        ),
      ),
    );
  }
}
