import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './localization/new_localization.dart';
import './providers/auth_provider.dart';
import './screens/home/home_screen.dart';
import './screens/loading_screen.dart';
import './services/authentication/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';
import 'routes/routes.dart';
import './screens/splash_screen.dart';
import './util/localization_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {
      setState(() {
        _locale = locale;
      })
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          locale: _locale,
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "Lato",
            textTheme: const TextTheme(
                bodyText1: TextStyle(color: textColor),
                bodyText2: TextStyle(color: textColor)),
            primarySwatch: Colors.blue,
          ),
          supportedLocales: [
            Locale('en', 'US'), // English, no country code
            Locale('fr'),
            Locale('my'),
          ],
          localizationsDelegates: [
            NewLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale?.languageCode &&
                  locale.countryCode == deviceLocale?.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? LodingScreen()
                : SplashScreen(),
          ),
          routes: routes,
        ),
      ),
    );
  }
}