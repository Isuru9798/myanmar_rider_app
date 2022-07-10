import 'package:flutter/material.dart';
import '../../../../components/common_app_bar.dart';
import '../../../../components/nav_bar.dart';
import '../../../../constants.dart';
import '../../../../screens/home/home_screen.dart';
import '../../../../size_config.dart';

class LanguageScreen extends StatelessWidget {
  static String routeName = "/language";

  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.5,
      ),
      drawer: NavBar(),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              title: Text(''),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: backgroundColor),
                onPressed: () =>
                    {Navigator.of(context).pushNamed(HomeScreen.routeName)},
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
