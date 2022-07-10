import 'dart:convert';

import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';
import '../../screens/auth/register_screen.dart';

import '../../screens/home/home_screen.dart';
import '../../services/authentication/authentication_service.dart';
import '../../util/localization_constants.dart';
import 'package:provider/provider.dart';

import '../../components/button_component.dart';
import '../../constants.dart';
import '../splash_screen.dart';
import '../../size_config.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  init() {}
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();

  String email = "", password = "";

  bool isLoading = false;

  // callback(status) {
  //   setState(() {
  //     isLoading = status;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: getProportionateScreenHeight(280.0),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: boxShadowColor1,
                          offset: Offset(0, 15),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(79.0),
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(320.0),
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(40.0)),
                        Text(
                          getTranslated(context, 'login'),
                          style: TextStyle(
                            fontSize: 20,
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: false,
                        ),
                        SizedBox(height: getProportionateScreenHeight(20.0)),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: getTranslated(
                                      context, "enter_your_email_hint_label"),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return getTranslated(
                                        context, "enter_email_address_err");
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return getTranslated(
                                        context, "enter_valid_email_err");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(20.0)),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: getTranslated(context,
                                      "enter_your_password_hint_label"),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return getTranslated(
                                        context, "field_required");
                                  }
                                  if (value.trim().length < 8) {
                                    return getTranslated(
                                        context, "length_password_err");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value!.trim();
                                },
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(5.0)),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  getTranslated(context, "forget_password"),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(50.0)),
                              ButtonComponent(
                                colorCode: primaryColor,
                                text: getTranslated(context, "login"),
                                isLoading: isLoading,
                                func: () async {
                                  // callback(isLoading);

                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);

                                    _formKey.currentState?.save();
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .signInUser(
                                            context: context,
                                            email: email,
                                            password: password)
                                        .then((value) => {
                                              setState(() => isLoading = false),
                                            });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30.0)),
                        Row(
                          children: [
                            Text(getTranslated(context, "dont_have_account")),
                            GestureDetector(
                              child: Text(
                                getTranslated(context, "sign_up"),
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  RegisterScreen.routeName,
                                  (route) => false,
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(30.0))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                title: Text(''),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: backgroundColor),
                  onPressed: () =>
                      {Navigator.of(context).pushNamed(SplashScreen.routeName)},
                ),
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

// void SignInUser() async {
//   // authService.signInUser(context: context, email: email, password: password);
//   await}
}
