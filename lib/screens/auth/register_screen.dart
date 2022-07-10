import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../models/login_model/login_model.dart';

import '../../models/user_model/user_address_model.dart';

import '../../models/user_model/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';
import '../../services/authentication/authentication_service.dart';
import '../../util/localization_constants.dart';
import 'package:provider/provider.dart';

import '../../components/button_component.dart';
import '../../../constants.dart';
import './otp_screen.dart';
import '../splash_screen.dart';
import '../../size_config.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = 'register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService authService = AuthenticationService();

  UserModel user = UserModel(
      userAddress: new UserAddressModel(
        addressLine1: "",
        addressLine2: "",
        district: "",
        city: "",
      ),
      id: '',
      userFirstName: '',
      userLastName: '',
      userImage: '',
      userStatus: true,
      userStatusString: 'Pending');

  LoginModel login = LoginModel(
    loginEmail: '',
    loginPassword: '',
    loginMobile: '',
    loginType: 'Passenger',
  );

  String _dcode = '';

  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  String initialCountry = 'LK';
  PhoneNumber number = PhoneNumber(isoCode: 'LK');
  bool isLoading = false;

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          getTranslated(context, "register"),
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
                                  labelText: getTranslated(context, "email"),
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
                                  login.loginEmail = value!.trim();
                                },
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(10.0)),
                              InternationalPhoneNumberInput(
                                hintText: getTranslated(context,
                                    "enter_your_mobile_number_hint_label"),
                                onInputChanged: (PhoneNumber number) {},
                                onInputValidated: (bool value) {},
                                onSaved: (PhoneNumber number) {
                                  _dcode = number.dialCode!;
                                  login.loginMobile = number.parseNumber();
                                },
                                selectorConfig: SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
                                ),
                                ignoreBlank: false,
                                autoValidateMode: AutovalidateMode.disabled,
                                selectorTextStyle:
                                    TextStyle(color: Colors.black),
                                initialValue: number,
                                formatInput: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true, decimal: true),
                                // inputBorder: OutlineInputBorder(),
                                inputDecoration: InputDecoration(
                                  label: Text(
                                      getTranslated(context, "phone_number")),
                                ),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(10.0)),
                              TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                controller: passController,
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  labelText: getTranslated(context, "password"),
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
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(10.0)),
                              TextFormField(
                                obscureText: true,
                                autocorrect: false,
                                controller: confirmPassController,
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                  labelText: getTranslated(
                                      context, "confirm_password"),
                                  hintText: getTranslated(context,
                                      "re_enter_your_password_hint_label"),
                                ),
                                validator: (value) {
                                  if (confirmPassController.text == null ||
                                      confirmPassController.text
                                          .trim()
                                          .isEmpty) {
                                    return getTranslated(
                                        context, "field_required");
                                  }
                                  if (passController.text.trim() !=
                                      confirmPassController.text.trim()) {
                                    return getTranslated(
                                        context, "confirm_password_err");
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  login.loginPassword =
                                      passController.text.trim();
                                },
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(50.0)),
                              ButtonComponent(
                                colorCode: primaryColor,
                                text: getTranslated(context, "register"),
                                isLoading: isLoading,
                                func: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => isLoading = true);
                                    _formKey.currentState!.save();
                                    await Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .signUpUser(
                                      context: context,
                                      user: user,
                                      login: login,
                                    );
                                    setState(() => isLoading = false);

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //       content: Text('Processing Data')),
                                    // );

                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(30.0)),
                        Row(
                          children: [
                            Text(getTranslated(context, "have_account")),
                            GestureDetector(
                              child: Text(
                                getTranslated(context, "sign_in"),
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.routeName,
                                  (route) => false,
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(30.0)),
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
                leading: Container(
                  // color: Colors.red,
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(11)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: backgroundColor),
                    onPressed: () => {
                      FocusScope.of(context).requestFocus(new FocusNode()),
                      Navigator.of(context).pushNamed(SplashScreen.routeName)
                    },
                  ),
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

//  signup function API
//   void SignUpUser({
//     required UserModel userData,
//     required LoginModel loginData,
//   }) {
//     authService.signUpUser(context: context, user: userData, login: loginData);
//     // if (code == 200) {
//     //   Navigator.of(context).pushNamed(OtpScreen.routeName);
//     // }
//   }
}
