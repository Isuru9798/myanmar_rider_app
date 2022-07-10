import 'package:flutter/material.dart';
import '../components/button_component.dart';
import '../constants.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/settings/language/language_screen.dart';
import '../screens/home/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../size_config.dart';
import '../util/localization_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isLoading = false;

  void _logout() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.remove('user_id');

    await Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isLoading = false;
      });
    });
    Navigator.pushNamed(context, SplashScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              accountName: Text('Isuru'),
              accountEmail: Text('myemail@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://image.shutterstock.com/image-photo/profile-picture-smiling-millennial-asian-260nw-1836020740.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(getTranslated(context, 'home'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (route) => false,
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text(getTranslated(context, 'language'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LanguageScreen.routeName,
                  (route) => false,
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.update),
              title: Text(getTranslated(context, 'trips'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.wallet),
              title: Text(getTranslated(context, 'wallet'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.backpack),
              title: Text(getTranslated(context, 'package'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.water_drop),
              title: Text(getTranslated(context, 'water_delivery'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text(getTranslated(context, 'rent'),
                  style: TextStyle(fontSize: getProportionateScreenWidth(16))),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                getTranslated(context, 'update_profile'),
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            ButtonComponent(
              text: getTranslated(context, 'logout'),
              func: _logout,
              isLoading: isLoading,
              colorCode: secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
