import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:to_do_list/common/screen/app_settings.dart';
import 'package:to_do_list/utils/authentication.dart';

const textGreetings = 'Hi,';

class Greetings extends StatelessWidget {
  final bool isHomepage;

  const Greetings(this.name, this.isHomepage, {Key? key}) : super(key: key);

  final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: FractionalOffset.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.8,
                alignment: Alignment.centerLeft,
                child: Text(
                  '$textGreetings $name',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 40),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              isHomepage
                  ? Container(
                      height: constraints.maxHeight * 0.7,
                      width: constraints.maxWidth * 0.1,
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.gear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AppSettings(),
                                ));
                          }),
                    )
                  : const SizedBox(),
              Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.1,
                alignment: Alignment.centerRight,
                child: IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    Authentication.confirmationDialog(
                      context: context,
                      confirmationText: 'Do you want to log out?',
                    ).then(
                      (confirmed) async {
                        if (confirmed) {
                          await Authentication.signOut(context: context);
                        }
                      },
                    );
                  },
                  icon: const Icon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
